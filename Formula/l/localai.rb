class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/releases/download/v4.10.0/LocalAI-v4.10.0-source.tar.gz"
  sha256 "5589402839753647e3ae666b724e97f3951c4863587dff47bc56efdbd5500f91"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a66480f5d6c99368475b8f8548241e3dd72f6d9b2343b82cc7d43840c853fa69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8287cb98a9851c99019f23d1d43bb5af1a729f33ea7150d77ddcd69f5df86a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3de808e51e42bff2931561497df2aebcf8a642334145fb8900ecdd234c3bd50f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b2d375bc4e6bbbea8a9edc48571bc4860c0bd6f29b7bc6d07b1d8013e826ff75"
    sha256 cellar: :any,                 x86_64_linux:      "9faf005dba21df04a5b6e3a396084624fce4465a4311c45c939dc557e3c4ffd1"
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

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
