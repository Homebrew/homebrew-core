class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "595ade8031a8f7d4fd23c4e3a5c24b37f542059f3585c9f15352da4fb79c06e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916762f5f150ed512bb360288131b670e6427b526e6e480f4511d4f93514f930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98e12b6113ea36844382ce0595a5d14b4ff2fd9337cb4a7c4ceb9406e1a8b85d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d90aa4ed4e526312efa24791ea0d3d674dbff652598649fac15ca946abbddde"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfd6d4afaffd374de8c1b79f9f4116e5e7d23e0fe35efb3435c96bf8abe435c7"
    sha256 cellar: :any_skip_relocation, ventura:       "69404bfbc7780df4439d1dd6f89df61685800699d2863b8001f8486462b4565d"
    sha256                               x86_64_linux:  "8661a59a281d2837ee130910cf4b838c608f0d5bd1d9307e5d8bb047e2ae952b"
  end

  depends_on "abseil" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "grpc" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build
  depends_on "python@3.13" => :build

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/05/d2/c0866a48c355a6a4daa1f7e27e210c7fa561b1f3b7c0bce2671e89cfa31e/grpcio_tools-1.71.0.tar.gz"
    sha256 "38dba8e0d5e0fb23a034e09644fdc6ed862be2371887eee54901999e8f6792a8"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
