class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "5325d60bd989040e1246453ecc9f2122065b8156b778b59a186cc0736811582c"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08abf2d92295ec3c46c943bdfc3bb49dc3020cb8e6b657cd36d50c90d905db12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4be1b2451ea3b3de53386e19fa803319571e4a6939b50f40d8b5d57ae686ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8046d90b1333fa4e5bbc7e16df5573cac01fa2603738603e27d492a969ba0045"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddd45fe6a64ca6667a5d23e8044dc66b14b2ba8703854c6a3522751e6af5a0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad08ec6dbbb9459ccce726a07486018ddc796d9f86ca5002a286a5c289dd91e0"
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
