class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.3.6.tar.gz"
  sha256 "e170a9cbf8fd6ac600efb45fbc43983523d8684610d2b46bf919eead74443cc9"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bd0c4ca91e8cfd67d9eba5d3dd5614cdd93f8ca2612e44c33763e375159ec25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb898347144b182dda426c6883934a7a66b15464052a770478612684ac648ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bde303d837eaa26247e675149c7d12f134d76f8c01cd3c9f822908f129d254a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7dc1bb842d9c5346a384e51d4233e2f41c8c84a12f69887b44fbee76749c86a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46ca16ec5ff78742c981a1223c3a92a9b45ee01314a7771d5a9ae23282358db9"
    sha256 cellar: :any,                 x86_64_linux:  "02bc6cd697ddf151bb332691327d27d0d9726a7552441c6577bf7a8c001df62d"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    pid = spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
