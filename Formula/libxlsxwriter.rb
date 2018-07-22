class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.7.7.tar.gz"
  sha256 "cce28d1a7e7887b105c7b0fd20b7be84f62070569f7a28e7779ceaec6be3847b"

  bottle do
    cellar :any
    sha256 "67272ba5b0280fbd3a7e9b0c13a1eb22a320d66247f9348e2f89f048ebb8f695" => :high_sierra
    sha256 "d0522539d53aa15f38fc371c0c81c9d2e0f6c247532de2a2b0330f556eb93aa5" => :sierra
    sha256 "b5de17012d7a68ea786dbb2d7a638b8e39adbf7bd6c512fbbb474bd4f14f29a1" => :el_capitan
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
