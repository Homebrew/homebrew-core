class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.0.8.tar.gz"
  sha256 "a0074a63eafc120ed9c59560d1a198a1c2a054ee33f40cadf7101e8f9cfba8a6"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "98dc5b126bb7384519f4653c17ee9c42ce8d20bd71fc10fae15aac346e0db7c1"
    sha256 cellar: :any, big_sur:       "2e4a46d19d9b8a2845d4bbe7e182210050940932bd4cc32204129086353e8806"
    sha256 cellar: :any, catalina:      "c62b8c975d8f53a9841f34fb456647bb43e31db66c535cc2fb2740ccafb44aaa"
    sha256 cellar: :any, mojave:        "5bf4db3205b2bc60dd8ad5735210064d45274bebd3ea6e65754a446bd848773a"
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
