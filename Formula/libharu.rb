class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "https://github.com/libharu/libharu"
  url "https://github.com/libharu/libharu/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "d1c38c0492257c61fb60c85238d500c05184fd8e9e68fecba9cf304ff2d8726d"
  license "Zlib"
  head "https://github.com/libharu/libharu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "32b1536e7d401ca8a1bf7e141b341f3dc4870a3448ecf07fadc9020bc0af7232"
    sha256 cellar: :any,                 arm64_big_sur:  "3b3ecb6741fc471fdcabdf35215911fe21ae1eea3c7fe331198c3d614e28fe32"
    sha256 cellar: :any,                 monterey:       "7331df46dd1a66ce9f7ee7733764c070dedded9c766c42ab2b9648eb4144dcd2"
    sha256 cellar: :any,                 big_sur:        "fd5a1906e1b050f159f94f44d037cd50b0eb242a6f56a48f42e2085331e6dace"
    sha256 cellar: :any,                 catalina:       "41becd02e09ddf3c566e69d7c8b2a0c52d571fb754ccff155d5e5d630d8eb64b"
    sha256 cellar: :any,                 mojave:         "3ae8ecb2883c97e36e027d3ee6d81cf2aeaeccbf5e11616a4b06f2c229c74e35"
    sha256 cellar: :any,                 high_sierra:    "70363d91450426724b94040b3fc5130d0e024fc13e08e5747cf47017fb94c76e"
    sha256 cellar: :any,                 sierra:         "860cda2675feea36f82f4b8108927c6a0b1cabca5429c119f63557da11394f74"
    sha256 cellar: :any,                 el_capitan:     "68003e06f893b8df9d412960a06c69f6b45cb4ab5abd96e9f10c5936ab8724ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe78364fa33562f2bdee06c1dfabb867ebbf50810f64fbb5d05f127dc74b106"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  uses_from_macos "zlib"

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "build-static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build-static"
    lib.install "build-static/src/libharu.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hpdf.h"

      int main(void)
      {
        int result = 1;
        HPDF_Doc pdf = HPDF_New(NULL, NULL);

        if (pdf) {
          HPDF_AddPage(pdf);

          if (HPDF_SaveToFile(pdf, "test.pdf") == HPDF_OK)
            result = 0;

          HPDF_Free(pdf);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lharu", "-lz", "-lm", "-o", "test"
    system "./test"
  end
end
