class Localai < Formula
  include Language::Python::Virtualenv

  desc ":robot: The free, Open Source OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "54dd442498263657b8953a767db0a31ad86591130095a42d84ecbbd8c795d880"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "python-setuptools" => :build
  depends_on xcode: :build

  depends_on "abseil"
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

    # We exclude gpt4all backend because it is causing an issue between
    # CMAKE_OSX_ARCHITECTURES and the CXX compiler targets architectures. Check
    # out the list of backends available:
    # https://github.com/mudler/LocalAI/blob/master/Makefile

    grpc_backends = ["backend-assets/grpc/llama-cpp-avx2",
                     "backend-assets/grpc/huggingface",
                     "backend-assets/grpc/bert-embeddings",
                     "backend-assets/grpc/llama-cpp-avx",
                     "backend-assets/grpc/llama-cpp-fallback",
                     "backend-assets/grpc/llama-ggml",
                     "backend-assets/grpc/llama-cpp-grpc",
                     "backend-assets/util/llama-cpp-rpc-server",
                     "backend-assets/grpc/rwkv",
                     "backend-assets/grpc/whisper",
                     "backend-assets/grpc/local-store"]

    ENV["GRPC_BACKENDS"] = grpc_backends.join(" ")

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
