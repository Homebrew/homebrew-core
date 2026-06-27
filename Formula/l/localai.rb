class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "b48e0fcf099ba439ba443e58a2308fefa0e25ea852df7e3210e882c1cb16c603"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44331f85fcdb04e518e9a0dbc0eabda4828ec5f5123860409b851448e19a8824"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5f23077714d0c8c4c73a6d3a005e9901a9a9abbb814120303ee02644f32400d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0efda048bb51f4fe079eb5130950088649371a99ff976940001f9220d5a340c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eabaeced4a61edc873a25a923adc630e1cc2001c98e386205b3693b77d6f8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "526d68c7f9bd9d9667aed80b7c3154d90b97cd87a1414e0e6aa5149eaedc5b51"
    sha256 cellar: :any,                 x86_64_linux:  "bc721938e728b548528cac64fe1a7109fedc22bc823a5fbcf92a05c9f4dff8d3"
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
