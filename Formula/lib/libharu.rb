class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "https://github.com/libharu/libharu"
  url "https://github.com/libharu/libharu/archive/refs/tags/v2.4.6.tar.gz"
  sha256 "ec8f327520d1d354ce58b5d2af75b64f380cddc522437c169463b39760921348"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libharu/libharu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c711120c3924fc180e54f7948b7c21ee8e9695d61d5e614ce491cc57c2ea70b"
    sha256 cellar: :any,                 arm64_sequoia: "eac020c6b4a0a047413108e13b3c89707bb08b03053de172a0a13ba2f5c1b369"
    sha256 cellar: :any,                 arm64_sonoma:  "fa4b1635cf0425bec217bc1e613a6699164ac0f9dad5f6d174bc200ab79d06ba"
    sha256 cellar: :any,                 sonoma:        "69ade359b587a875817d7aa5137faa666734ff472c813845947cdb9d16d8233f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa203be6dc180fdac5d3e134a65eab72cb770631f589ee888dd0794c0108e6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946728db7b2ce4a26d05ba314d33a399539ca79dbe2d47059be659fd54242028"
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
