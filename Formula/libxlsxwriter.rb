class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.8.7.tar.gz"
  sha256 "2544324eca82d307b795d90f2da4cdd1028db3d21c64851dfce27d9174cc7087"

  bottle do
    cellar :any
    sha256 "a0108b3fd598b490b4705dc3087ce97f02f1635b57604e90571acbd86e0ec9a9" => :catalina
    sha256 "032f628bfb43e3fa5108db3feadd521a51b8c4494bf3e3235d7840648fee1334" => :mojave
    sha256 "c63a03bfdb9284391d5081300d037aea88e9cec0e888e014998dd121d6343013" => :high_sierra
    sha256 "212ed6216f90977a3cd0bb173a51f6061263db2a3391a3c3fcf0d09df80ed176" => :sierra
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
