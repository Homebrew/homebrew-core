class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "eb582ece161bb94723c702267e68a6391fb1514994f9f5410ce2cc973a0ba91d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f89597c30561817f0eeedf8588eeaae5d7f08fbc4c3dc1f8c7b67f335195750a"
    sha256 cellar: :any,                 arm64_monterey: "bbbdf23694c554d6d5cf178e14c7ba1d83f8b0ad30ec7aee2c86c4fe54f1856a"
    sha256 cellar: :any,                 arm64_big_sur:  "a900b2b9908c08904e2788d6e34670d75ef3d06236a0528e68fd69994d0a7817"
    sha256 cellar: :any,                 ventura:        "f9bdadd4391a8b7e81cb71724eb6ef9dd647f7bd18726258abee15937a3b253b"
    sha256 cellar: :any,                 monterey:       "41b8dbce2783e0c632df955d1db941ece24cd0680dd247f475c6f35537e5bd69"
    sha256 cellar: :any,                 big_sur:        "b51760890463b0efb0af5527742aa3d7152477e1994cdc123126b25f428bbe6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1695bdcf90406d04977acc7e1f9befbed5c68efa77494252c9d0fb85dad1ef16"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
