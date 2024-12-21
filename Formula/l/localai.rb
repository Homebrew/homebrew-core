class Localai < Formula
  include Language::Python::Virtualenv

  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "6dd03d21c4c903890bd2bdc6c18b4a1191b1a79dc296ccbf817d773cdcdb401a"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "99415822dc2eea2d5b91b2782ba25ed0fe40fa35d1207418c64806f282e9f27f"
    sha256 arm64_sonoma:  "342425c0a68851e8591a2577abc459bdfbe675863c568e4333c0b3a1e1cc4408"
    sha256 arm64_ventura: "9c5e4bef1477bcb92388ba94a06c298ddb7157e9947d97df88bfb635298e4398"
    sha256 sonoma:        "860eed1a69867f545fcc78d14cfe1d70f4a6c809cbe114f3504cf54a3155c672"
    sha256 ventura:       "d458baf4fb2261a0727bcf5de266b82ead7269a7297a6e2f0956c3f3660228ae"
    sha256 x86_64_linux:  "b27ae91f9e9f7a46cee70e912ea4d375bf93e60af046a5d22b08fe2ee21ac50e"
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
    url "https://files.pythonhosted.org/packages/2a/2f/d2fc30b79d892050a3c40ef8d17d602f4c6eced066d584621c7bbf195b0e/grpcio_tools-1.68.1.tar.gz"
    sha256 "2413a17ad16c9c821b36e4a67fc64c37b9e4636ab1c3a07778018801378739ba"
  end

  def python3
    which("python3.13")
  end

  def install
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

    response = shell_output("curl -s -i #{addr}")
    assert_match "HTTP/1.1 200 OK", response
  end
end
