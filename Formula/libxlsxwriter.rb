class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.8.7.tar.gz"
  sha256 "2544324eca82d307b795d90f2da4cdd1028db3d21c64851dfce27d9174cc7087"

  bottle do
    cellar :any
    sha256 "58c96659bf6494f763de22ae71987eceae4ffaee435c0a2b1abf650e344f2c30" => :mojave
    sha256 "782a11914d19ded90406f33afc652da077589b83c0b06a87674c060c7c2a8ee3" => :high_sierra
    sha256 "01237e26925d66577f5aae0941a6160a3be059f70ca32adbfa13bcfdccd8ffe9" => :sierra
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
