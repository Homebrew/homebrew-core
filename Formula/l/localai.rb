class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "b76d21b19df905e0f2719c5417072976ae3f3243ceff764bb1914d5139136d52"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bca8820ed974a52a3f7e7fa4ecf3eec0eb68402b879d2f4144995bb6bb48beff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaa1e2474d3020dee43e2621b4526066754bf85fff1d0f2485ada38390a25f0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77234aa7443aff3f54c528fa13fedb32cece183048b1ba8c520a79b735e1ae2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d4f985d843480ac050496fd8f80bf1274959ab6a5f5387161db7acb722142a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72ed32aff8506ecc3f910c5c8f45d52e1ed21e7ccaf766a04cfa53926218fe65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "733da62f810e98600d106cd7cad8d0453b028eaf18972df724eae873e8947e63"
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
