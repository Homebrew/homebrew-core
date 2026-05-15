class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.2.4.tar.gz"
  sha256 "a2e0111ba38461a377d2814862f132ce176771e33e4ec08f40426aa09d95569d"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f5dbf8f1510a007e166ec9ddd65355b401cc377c767a9332a3bd0b06255063"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61e2aa441038e87d55e4f50e618602dc35e5e18512fd4e3b8497d584a83c57ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d53e72e355f12e74b0fefcb37fa74e058f48e7393494edcdb117250b8ba97bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "208a8ada4fef94cb50dd189b710a7444721ee2df1d80dde48b4a5fbe2e388571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cdaa5a62fd9ff39e8c6bb6a92f7a191ee46ae0ffe1a375724697c64c3495446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8df6c390f92899069ed73a9242934d73288710d4527649d795b7ddaea7e4d332"
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
