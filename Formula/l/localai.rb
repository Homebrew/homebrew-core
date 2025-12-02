class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "869aba75d65ea6c24972c35e7518a4790eeceaf3aba1a48b9067361e05aa27bc"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ed3f3693557e65c8236eb911b24f06f24fa90d0fa7ad6dcfc5fa42e5402b44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4d6b8d07c59341e8bc20c76ba1874e1c02864757c85ac2f4a40ba96c809234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cd14cba3357834af20799724296d6ad0bc24d5317e86d898e79bcb24beb5870"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f15357bbacad2d1ea3147b6c36bdf8c2847c908230324e10bfe042276b1283f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a48d3344b36e4944795f1275041f15ac30b95694fba1cae75cf3dbd25dccda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9317153baa5d543936d786baf44988ab058ec7881f42fbcfd692aee769f93740"
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
