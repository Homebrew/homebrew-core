class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "9ab87e9baaf85c21e9c2f9b73d346eedb02f14a4766e0125e9aac36f8b3d2d59"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6736e4c9ea160f01e9f679af47c5ae8ccd6e62e5f859c13eec7a7b814d673cdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78c6b420b7774f0e4db13875b6aea4a5519357b26a01898d9d5075ec7bc6ea91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca3d05f93c9e606deaffa442e150667a49e61d3a2b38a8ed94de0498fef49e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "99332128a15f4db598d4b033474e2769372a43994642e544a6d54d98a5c56954"
    sha256 cellar: :any_skip_relocation, ventura:       "c8c2a8e818e588846300a67d8bae0dcfaa17b74d79a204bbb7de2aeb43989c6e"
    sha256                               x86_64_linux:  "22e4e42166bb2917c51aff02646633b5c59d61227b7e47bc115b947f4064dd24"
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
