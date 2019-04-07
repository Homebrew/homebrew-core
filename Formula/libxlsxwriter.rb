class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.8.6.tar.gz"
  sha256 "76cd0d10dbb4e0f38814c89bbdabd49b329a84eb5b4b12135c0550b633c09d51"

  bottle do
    cellar :any
    sha256 "cbef59c2a52687113638706b217835d6d4cfaea4db03cd7b7c97e976a182ea1b" => :mojave
    sha256 "1f030e7555709f68bc366e633036d2a555e9015a389446013d90e1f646a9c174" => :high_sierra
    sha256 "e51d978f5a153b8b68f21a37f4ee170ac61981cc42476af1b97266ae06d7e637" => :sierra
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
