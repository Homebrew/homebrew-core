class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/releases/download/v4.12.1/LocalAI-v4.12.1-source.tar.gz"
  sha256 "7e47078e3e92439e7539d331150c0941a1350228c874de6ec641aee21685bd8c"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4269b74ce4f3ca31c01cfb520b282f3b486a818c289fb4cad216266f8593827"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fb3fd84cfac15777960230a60cbd728ef991075dcbd04535a8d68ecf56f9a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce9ff0d942144b587407605b66c1d3b411947f1fdb1f96100ff076782a821a77"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "361003f0b2215bfaf8555631019b1623a6baeb78a62ef5244db5114436a2dba9"
    sha256 cellar: :any,                 x86_64_linux:      "948aa4c7a035d882b45b5cc358b2d084c5df4f75369ce7f3be56103584cc0019"
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
