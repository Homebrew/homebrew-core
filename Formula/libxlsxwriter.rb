class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.7.6.tar.gz"
  sha256 "e300365acf5cb2d6bc8efd4c50e7b2ce2943908a72acfa55a41c81766601c8c8"

  bottle do
    cellar :any
    sha256 "86198925f436e9529990846ce8027ea7962747201a4d52722a6eee13e370c427" => :high_sierra
    sha256 "e30086361ba37be6417138e270b4de4d5df92fadcd6be9b40502391d548a3ee6" => :sierra
    sha256 "1d86b5ae35b830b6dbd69cb8289920dfd4dcfb8a498d4d0988e9daa569b3dcc2" => :el_capitan
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
