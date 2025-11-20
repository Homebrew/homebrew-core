class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "3481e10fff8eedfcd4ac734998f1b0832e34d794c8b8637ebec15a87a927fd04"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f40ec891d2ff6429ce5519d758436fb04fca19f269ae6f64b3a8dfbe155262a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e1fe131d7fb9ab0f50c42951222e585cd3888df8fc152bb3dd9924120ea0963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53f921f9b58d2253f6bee8b9ca93f496555455ad5bea8f471f5fba7d3625c1ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "99bac87386304a645af4f5a3925df5ba9797792e5e6f7e8c949ddb6a21d051bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21e105d3781146806b6cdca1dad620c3ddae9dff8443285d8ee81d36eb871b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6902a42f3729e1f1c971ef5873cc0e0b2ef3f7954cfefd58635161236d9e99c4"
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
