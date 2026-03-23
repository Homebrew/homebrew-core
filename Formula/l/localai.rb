class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "6673edefdff0e2f1373ae35348b11e95638eb94850326d0dbd9fbeee6b5f16bc"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eed9842b455cd9b222fe2e0b487e87f0413d322281edd1688847ff4c63121a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e79f23c64f62b8f44608d760180b9fc46a5d0a2c066800e81f94dd4caa81a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbfbaa9ae2f344d6c8358bec62c84534bd27254e94fead39555ad22ad5b045c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e990a67c05fe3d7d8fe34891e1aa5e3816fbf2adfb11f4a0d17ec25f13f898fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa2d54d7e65b5b720b0e04ebe145ef4dc57204b4bfef8c7880d624c3b58ce2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "325d6788ea9735adcff329302c9ca216650e32452b0704fd501317d5eac39bd7"
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
