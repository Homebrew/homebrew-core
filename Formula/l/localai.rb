class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "8e1f3fc1a89a0647c6ae9a1ea21bd3447416eaf37b872296862d54d3c9d71869"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "453a441b5c0bf48a06dbdfbe38f99b385a0b779bcd2702e75221ee15e4729057"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "744ecbf13ddb29c7eefeab63b70ad79c40e37a1d3fe83149faf47964b1a78305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a664281233fffdefec499b3fabbbf461da9c21335736ca27a651715230c6f1ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4b1219317e33246dc66d15ae2e8ea7e427a2767fcc07cab0b0870e915563d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e486e090c71d8e3c02fd4d1c95b37da3d181fbf26f955a5357414ae1e5d5105"
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

    spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
