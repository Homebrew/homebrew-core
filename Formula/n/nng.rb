class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://github.com/nanomsg/nng/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "ff882bda0a854abd184a7c1eb33329e526928ef98e80ef0457dd9a708bb5b0b1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "39282ce6d5eb11d4887f659138576130e7bbbf2fbe0f5037e6f0e125f77d2231"
    sha256 cellar: :any,                 arm64_sonoma:  "cee738170b8eac76fe3db0790850242c30b34fc7f72fed41f94cf67fe51ba021"
    sha256 cellar: :any,                 arm64_ventura: "1e75bbcd3115c7c7cad62926044001fcb6db534661e6d2754e01f49548981355"
    sha256 cellar: :any,                 sonoma:        "674febf52f58ae7f2afb6418ec4ee6f431015acb10bb733e223bf197067e3805"
    sha256 cellar: :any,                 ventura:       "8a5496f1d6e3abd7087da2c19f367cc3506d0d5d99856ff759b35eee6d2501b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd2aa82a113b465a5d6188f7a47781ccbf10a33971d2990de57e1d16289c0e0a"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

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
