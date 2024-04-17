class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/RELEASE_1.1.7.tar.gz"
  sha256 "1f378e25d8bb5be258d3e04d3d24b8c23ff21bf206e6e206661844a96ca25eda"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcdd85a6317509a40dad85ae6d01787cce836aa7a1ee0c68f271a6ffc3c24105"
    sha256 cellar: :any,                 arm64_ventura:  "0abd30edf3d9e22ee7bcd40db69bf72533b5b4fe78dc955ed768a61713353d35"
    sha256 cellar: :any,                 arm64_monterey: "727d1888edf44e1ab6d492f1e93fd2dc16cf30ea2f6e7c645af869c4fbfc669f"
    sha256 cellar: :any,                 sonoma:         "ee8449e171dfc128823cb694bff955828301b344a0a7996db6d2231f2f84a65d"
    sha256 cellar: :any,                 ventura:        "eda382730dfb62b2d36664aa5d5bf84eb74b07216260ccf051f670de92bce6bd"
    sha256 cellar: :any,                 monterey:       "42d5fd5887daf63689f95f8c7b00e202889847a30b8b02ab99a4cd17d1ef0673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73fbdacc0215ee565eae29791c17f9ad6fd1bbda2f3a93c4f2209e0a5ef84e18"
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "xlsxwriter.h"

      int main() {
          lxw_workbook  *workbook  = workbook_new("myexcel.xlsx");
          lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
          int row = 0;
          int col = 0;

          worksheet_write_string(worksheet, row, col, "Hello me!", NULL);

          return workbook_close(workbook);
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxwriter", "-o", "test"
    system "./test"
    assert_predicate testpath/"myexcel.xlsx", :exist?, "Failed to create xlsx file"
  end
end
