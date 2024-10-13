class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "3393c7121a2ff195efce1146a84daec21540e79ff72686ab7094197311133347"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5ee4dfff011715f6a0d8694e628205ce27ceac169eb10c02b827d7cb9e489f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d32a9f5f32f32aee864dc5d054399c036da5da4fba63c4cb0c5b3d74b7bd34c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c750911ca784d1ad4a6dd59a79f1dc0dee23a32038deac3458e2ed85aa155433"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f92d35ce47017f2994ab396e85f838f7e40658789de5354e831cbf2b438f1c6"
    sha256 cellar: :any_skip_relocation, ventura:       "5e587ef5aefe8052cbe3887700c4b6411e76a526da01319c19c99fa07b4ec546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e22feab7785ce23aa15b81dac8bf2d692f4e7070dfea635f96e40ef0a67f65f4"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    # Assert conduit version
    assert_match(version.to_s, shell_output("#{bin}/conduit -version"))

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = fork do
        # Run conduit with random free ports for gRPC and HTTP servers
        exec bin/"conduit", "--grpc.address", ":0",
                            "--http.address", ":0"
      end
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
