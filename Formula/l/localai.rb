class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "349765fa3f01539fc98e0d14bea90a05f2dffbc96afde4ec3afc979ea48d5dd2"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33ceb9b23f4d13a8ee39c9357d30fe71c20346cb4b84bea559a984fb6b2c0108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a8217bdaec7797161987a0679e75ea5c53eae820e648f3f089cdb533a6d9a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a95c5e6c084064dc2388b3fc3cee0956fa53a93023217a631a38a38c0c633cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7c32765fe73114537f5873eb6451616b97b58f2a81c24f2f43fa524317f294f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32f65bb86a88d72cf4530ac5962b0883e1c0fa9d0c42bab05a6f975949f57b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c0e8bdd091afedee86ed0032d4cf703075338c96883f9b751e0d56f15a5dc4e"
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
