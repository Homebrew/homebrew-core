class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.8.5.tar.gz"
  sha256 "27d81167386ac21dd7aaa1f0acd7869e4306428b22214fe76b735dbc5296fe92"

  bottle do
    cellar :any
    sha256 "d0e47b5891ec28207f29ed5dfbb3ac2433cf7ba3e97cd0f39487207aa492fd09" => :mojave
    sha256 "916fccae6a4f7ebdab3ef3c15bc43b29b9ed6b8f2a8a3dfec148190ffa19a289" => :high_sierra
    sha256 "a763fafaa4b6712b92fb344282abd253cba9614031795b5a85b614486e9444d9" => :sierra
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
