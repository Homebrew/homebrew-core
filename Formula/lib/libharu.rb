class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "https://github.com/libharu/libharu"
  url "https://github.com/libharu/libharu/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "0ed3eacf3ceee18e40b6adffbc433f1afbe3c93500291cd95f1477bffe6f24fc"
  license "Zlib"
  revision 1
  head "https://github.com/libharu/libharu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a5c693f01bbceadbc47a3debdb9bf41149de6e6222ad4f42741847bd62cf943"
    sha256 cellar: :any,                 arm64_sequoia: "fcda91482f44f56d5d98387adcfa10412de7216906deb0b27084c1d2ebf8f6af"
    sha256 cellar: :any,                 arm64_sonoma:  "ab07ca9b26a58c1510881ab2a032df5e955f3ddef02105045e9f4b1a809d1432"
    sha256 cellar: :any,                 sonoma:        "3316ccdae1f8e6dfafd938a05bd81a89932e2b41888dbd34195cc547b95c75fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ef3176620a5cd03469609ef74b71c4731200853dfd97acdc7ffb3e67edd55f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d421cad27dfa67545c699b9ebcba09b914f2bc9b309ec088b53db2c43bcc3a4a"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "build-static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build-static"
    lib.install "build-static/src/libhpdf.a"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lhpdf", "-o", "test"
    system "./test"
  end
end
