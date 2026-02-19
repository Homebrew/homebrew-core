class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "c26e7ff1d104e6a99437cdbc4bc1592eddc8ff4dd56c2474ff9a4576841e8fde"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c548fb9266fedc27b4b980568a0d9761b85ec3b21acd39facd3e8b905ee391d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8bf80a3650f90433b58da15e9d6ebb92c39361c8ca7eac5fbdf9a7fbd0a8e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50b832debc0a4ba58bcc1846a7eabd9ddd338bf49f605ee583b52a94661a1bb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57d68b54158c6d6d3194e71ebd8c5a59055d76309431645aa05963d21fce66c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d393dda48eae1f03ad41323920238695c69aeedb8a796968a4f0cf6667b115be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bd6d1b70f3a61c7f0160d66697f7abafd2d490063aa2de1b1366d8fbb2f4b19"
  end

  depends_on "go" => :build
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
