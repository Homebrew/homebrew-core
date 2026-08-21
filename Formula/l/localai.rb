class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/releases/download/v4.9.0/LocalAI-v4.9.0-source.tar.gz"
  sha256 "40a2a646efb123c203b9c1edb0b851651349fb4a33d3a4a526954b5a606f79be"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "576e05f62f7781510049436e280cbd1414e2438db80ed8adc526adcc09f92ded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0ad07fb58f532f5ce80e20414c096bc1c9a47b39bab28f905c331620ee686bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0919301465b662354f84c12fff7e5f8c0e2e990ea4fa784831259c5d1b2b890a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f98705be37e417c0728cf2757b9501c0eafa4ceb5465c5aca52a4b4e6eb0ceb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ae88add02f1a93745d4b2e7a1c7a3c32ca4e3b444521cc390383990e985fb5f"
    sha256 cellar: :any,                 x86_64_linux:  "9aeb80a45d3008904685b6730fe6761b44858b5066cbea6bb369c133034f6b63"
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
