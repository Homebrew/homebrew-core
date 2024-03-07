class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduit.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "5951a48343fab0083d29f41ca491e7a4d776d8a7771a78ff79652abed18d3ebb"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1dc5b8078be3eebedf0d8d8564f0b6330fc8bffd5b8cea736b8be03f83a833a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30c539fdef908685cdacb51e3646d91170f9bcfa8442b6e5e899e5dde9fba1dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb4c539662572f0d336b46a19d98acdc83630cacfebd401e9472d78e63a00779"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3d876cf37f0b65aab08bad62618294f6cbdd9c3440b4aed30608ce5b1bc8e98"
    sha256 cellar: :any_skip_relocation, ventura:        "478828ea8c51c0dd5cbdb83412d73a76a63c3d35f15bee258f2d090038a5421d"
    sha256 cellar: :any_skip_relocation, monterey:       "2d7f7321fbe463df3f52a527600d2de011a2af145b90590bfe40b68c6bfd9f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5337b57769257473919028f65af92c262ea99a33297bb6b284265727724d18c3"
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
    assert_match "grpc server started", (testpath/"output.txt").read
    assert_match "http server started", (testpath/"output.txt").read
  end
end
