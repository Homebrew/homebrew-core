class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "11526b3e582c464f6796fd8db959d4ee64f401b2f8eee461562aa193e951e448"
  license "MIT"

  depends_on "abseil" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "python-setuptools" => :build
  depends_on xcode: :build

  depends_on "grpc"
  depends_on "protobuf"
  depends_on "protoc-gen-go"
  depends_on "protoc-gen-go-grpc"
  depends_on "python@3.12"
  depends_on "wget"

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/9f/30/cd31c3a04814eb880d5e78cea768240c92fb5adaa158814c2b166356a0c6/grpcio_tools-1.64.0.tar.gz"
    sha256 "fa4c47897a0ddb78204456d002923294724e1b7fc87f0745528727383c2260ad"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.12")

    venv = virtualenv_create(libexec, python3)
    venv.pip_install(resources, build_isolation: false)

    system "make", "build"
    bin.install "local-ai"
  end

  test do
    http_port = free_port
    fork do
      mkdir_p "#{testpath}/configuration"
      ENV["LOCALAI_ADDRESS"] = "127.0.0.1:#{http_port}"
      exec bin/"local-ai"
    end
    sleep 30

    response = shell_output("curl -s -i 127.0.0.1:#{http_port}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
