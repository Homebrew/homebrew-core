class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.8.3.tar.gz"
  sha256 "4e398f175bec4f3c0783ce8f1ee251609aafa6422fd6ee87b8e5420d541b50ac"

  bottle do
    cellar :any
    sha256 "1420348c472d69c77c846b0279471df8e5e7b12eac154074d90a56f2b420b15e" => :mojave
    sha256 "ef7c150e3405ccfe1223f523b867424d37195ab5d14016fa64ecd5787c8a513b" => :high_sierra
    sha256 "468631bc3463fb62dbc975d4e0d7f4a601c1e63c024cb5281781a5065d585063" => :sierra
    sha256 "34990e97ff99d3fcf1c3c14cb93fa0ec727035bab75563598f54192f97734e88" => :el_capitan
  end

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}", "V=1"
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
