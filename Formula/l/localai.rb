class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "600ced1a86e4925485f573bdbf497b8743705ae30254856b108904d389f16004"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c87370dfec521e31e522a1e88bf1c1086ae6b800ef07d45435f69ecbcf0246ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a758edbde3968c0a2b6579cab3fb2df70001c3861e7212543d22404a292d51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b313678d347f534dee856595bcdb603fc608eea06f8cda2a9e70cab091fdcc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "91bec5ea897575e77e370d6bde1568d67e0cb0c62c8b1bcba089b51ff2b6e5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f00a8fde1697e4dfbde68222dce39ee8d92787bb338b26b52c19eab3e0c9fb06"
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
