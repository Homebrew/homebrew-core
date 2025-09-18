class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "fb843ac142bbea6c7fab165cfc0ca8a5f77a461bd98435d06b15f6b0a536b343"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d10e36576d4fe6ac1fdc9c66af697b66c65f6bd0920172b53946e86d847f239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc09ad3519a96a6c5a703c62f8ff3c5f6656712f0ca978aeec0bc1edef56e5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a776fa95b3db03684556e4e8f3a3494359f405a2f3df797a52cc8b0fe72274e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "62950255fc30bda53901bf2f883cc9a29bb4effcae323c172d23d3038330f1e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5005995145b88229e498bc500022bdfd26882626c5840bd50c3a2b39b6601bb"
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
