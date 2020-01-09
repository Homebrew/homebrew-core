class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.9.1.tar.gz"
  sha256 "149195ee216b1187a328ac2d334d77573410f7e75c36c0cf15a82ec67478e645"

  bottle do
    cellar :any
    sha256 "b9f55067b734773a5712bd29f9249dadee939796794d2a8645acd3ac28fa9d4c" => :catalina
    sha256 "8f7f4cacb5343b83bffa64bd81efe198d2fa04adb3a417a7b47afb021a105f8c" => :mojave
    sha256 "302ae1928c8d0f01e8f7f94db948cd602ac04fddfa746ff78012af9d1b390084" => :high_sierra
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
