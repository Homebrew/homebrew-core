class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "b75f7cffb3b105c1f5e7cd4aa2d5c18cf461b6af0977d150d654d596f1dc8d79"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b50f832facfac7f166ca59de5d3b7f241b10bcfe0dcdee6afec90b3d557e1812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c82bb99e40beb0bb781ecf1087d0a0c3deeca7f2423d177c831e5ee639db516"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27a1f5a845087a4604800f0eee1642747f95f68a4f9eb268f6180aba2cbd4638"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc8a9eb26fe99a47a098f82f050302a548f6f529b86c14f1b90f5f602e204b07"
    sha256 cellar: :any_skip_relocation, ventura:       "71df6ef43bb378c2fac806673579b47e5a717e0805a17227fd9ddea6b0070043"
    sha256                               x86_64_linux:  "3a36fc178cc6108855d3f75d2c7751d616e9a176901ecc5dc6dca9e2ff5e134e"
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
