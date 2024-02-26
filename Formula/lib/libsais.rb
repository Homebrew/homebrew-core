class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "6fdca431bb69a17f6d238723380f3572db81c37afa219dc1dea4d3838ef1c4f0"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb25e2aa9c4796fd44901bf69f11697255d10357889690c5094a299e17f8e080"
    sha256 cellar: :any,                 arm64_ventura:  "24f5a0d41dd70a160bb3ccd74329d7767a1f0442b860926eef62e114dd06cf33"
    sha256 cellar: :any,                 arm64_monterey: "be69235359d1bb384cea8b640cf7df6604376756c5caaeaeac3fe147f6ccd529"
    sha256 cellar: :any,                 sonoma:         "f6db8f69f7148a0a45cdc779890d8bd7eeb5af6a16f466c3fad5a8fc6c80fe14"
    sha256 cellar: :any,                 ventura:        "8ef5ba9ad7bf93b935c1034b16e891f3ae301aa48e0ccbb6c8e81a16912a3cbe"
    sha256 cellar: :any,                 monterey:       "26a6f6cf78735c7490a90d77b91a2064c877afa75b5cf245bcc1054f18f3fe1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5d57226dff427bc5f480bbc3cfbde5668cad12f0f90f806e4eecf088e3a084e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("build/liblibsais")
    lib.install_symlink shared_library("liblibsais") => shared_library("libsais")
    include.install "include/libsais.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsais.h>
      #include <stdlib.h>
      int main() {
        uint8_t input[] = "homebrew";
        int32_t sa[8];
        libsais(input, sa, 8, 0, NULL);

        if (sa[0] == 4 &&
            sa[1] == 3 &&
            sa[2] == 6 &&
            sa[3] == 0 &&
            sa[4] == 2 &&
            sa[5] == 1 &&
            sa[6] == 5 &&
            sa[7] == 7) {
            return 0;
        }
        return 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system "./test"
  end
end
