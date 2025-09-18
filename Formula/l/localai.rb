class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "ec0d15a0c0310fdbf92acde3f35438d380e3c660d1cff4fc76c1850088553fec"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fe68347f814e0759e160381c1abb4a07bb0d03890fb811f2b0d5d713eaa3888"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "658809bb7c86a4a3356d7d3fd586c8b64b1955a74956ab08bcfdfba85d722395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3df00beacd37590e061c0e9f7482b0706adc7a13af7a1f28195773e03b19c700"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3e0af1a30813e09f40adcdfca30032607a4439ab434da5de19d48f1ca4c9a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49971faa487593ba50eb13617327ee1ae6a3163957b2465cadabbac05314534a"
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
