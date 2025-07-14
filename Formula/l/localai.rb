class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "00e88b6fbbac638c9b1b3d1f46a70ac774d17e0e04e17880cbc463e98d403600"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a1186447df29fd6c7bae12eabada46360a290dbeaf250b5dae5ef44739beca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833a15e49838eb3ba6bf1927344521dd7be4c409b1daa396c4eafec2b3a97509"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92088650dea1da2f14f804496cd86ec96a744dd74560e0841d7c5862dff2264d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b21f6ff2402fb86ebaa752c17b1da12ca2158ae1e94af5a0d522395a4f292f1"
    sha256 cellar: :any_skip_relocation, ventura:       "7c25e53dccf97b99baffae0abc582f657f74dafc683e793327b9b1cfd70cd53d"
    sha256                               x86_64_linux:  "7f7f8232be6e6863f2482277f9e415405fae5717648d6ddbc2728d07cfa7ed11"
  end

  depends_on "abseil" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "go-rice" => :build
  depends_on "grpc" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build
  depends_on "python@3.13" => :build

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/0b/62/5f7d3a6d394a7d0cf94abaa93e8224b7cdbc0677bdf2caabd20a62d4f5cb/grpcio_tools-1.73.0.tar.gz"
    sha256 "69e2da77e7d52c7ea3e60047ba7d704d242b55c6c0ffb1a6147ace1b37ce881b"
  end

  def python3
    which("python3.13")
  end

  def install
    # Fix to CMake Error at encodec.cpp/ggml/CMakeLists.txt:1 (cmake_minimum_required):
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
