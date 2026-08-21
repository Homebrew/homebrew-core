class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "5be3d85a87dda65e3b71af2163819206d04de91bf7cd821ac3f7a95000c4123a"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0782eed000c41288fd2a0bb14443962fe16d77ef57e3bedd24e884ec8ba0d8f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72e6aa5c12cc7d6b6f2ddc1b840d7ca77e505b3d703d4560850fa39309478d57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2097f40dd7c0088ba5eedd8e8fd2e3760058a4fe56406c754a1f7b1c4f3904c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "71417b6e9516375738ce987251c00ecb492f1cb23a7f6e1e6ed1311c7273d1dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61e66d25b01b7cf9fd4a6e0eb8ac8dacc6a7f524bfa9645eee77fc50cd7c5698"
    sha256 cellar: :any,                 x86_64_linux:  "b219847e1a6b8559f1b588ac176ef5a86e160393cb3a18fa1b6d057acadf1791"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
