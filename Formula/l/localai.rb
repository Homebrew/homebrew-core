class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.7.1.tar.gz"
  sha256 "d07da9a474fbb3e0c3eec34af18935acac737250a84e6ae8b70f412d3f5c04a6"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fc405bc1deb4742e85d1d67d785acc7dfe64dd7958af945a5f838b5b1e08d4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d649de30fbcd9b61abe6dd1c3db0aa1f56d008a189c7b6e6df5f0b6ec1d6b3f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c40096f976feeef610c887750861611894f938cafadfd5bfd61a1713a410fb6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e6ca8e1cbedb9e763625dd627f021beb4cf9c4cae4e81b0f47b83600cd993c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d63e0bb8b78d7af5e4954c97dc6f970344c55a6f4a49e44248fb423778f4def6"
    sha256 cellar: :any,                 x86_64_linux:  "64bdc36e97936080de2c847f2bc4c00c28d0f3fa5652c34adec7f04ed75405e8"
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
