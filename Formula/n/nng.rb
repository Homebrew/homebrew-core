class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "e2fdcdf126b530e331b4727812b710629cdb5d90d230ce8f080e2eb520299d8d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ec1bef381a4d61836c1e3fa2d401d366ebe7adeecd7ae4c7a5bbe73a5943a972"
    sha256 cellar: :any, arm64_tahoe:       "bd6a1d41d16373cd33011f3e08f8d665670b9bead1edd2aa3045ae345950fab4"
    sha256 cellar: :any, arm64_sequoia:     "848aff0b27a0e33493e3df97158366dddb89d0387f783e90a9b1a66aba19c6ce"
    sha256 cellar: :any, arm64_linux:       "c344ae1f83575389f80b130d747575b915d9532a93e1957b12411ea87db039b6"
    sha256 cellar: :any, x86_64_linux:      "27451cd129626439c64fe15b864ecdd8c22e98420f96d48e345a493acda78f3b"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  allow_network_access! :test

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DNNG_ENABLE_DOC=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end
