class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.8.4.tar.gz"
  sha256 "36e66fd3b41306ad60de5d38e128a8ef6aa3f75fe102fb1becf5bd06bd7c7cda"

  bottle do
    cellar :any
    sha256 "24898a0e007eb8c8517a9449b4fdfc19a85ce1aa6634bae60d00fdfb40f2f511" => :mojave
    sha256 "1a63793c3867d48a4fa9092b55505e42a0625f0a0bc9d67d8ff07aba18f26f66" => :high_sierra
    sha256 "71601b5d316acb01b3e41b53526bf845ae7a5df758c626f72e5db0825ffd275e" => :sierra
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
