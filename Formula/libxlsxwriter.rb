class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.9.1.tar.gz"
  sha256 "149195ee216b1187a328ac2d334d77573410f7e75c36c0cf15a82ec67478e645"

  bottle do
    cellar :any
    sha256 "cf33696a0ac50e7794929a564232bd7e0f84999d935ba51d0c31595d2a3463b6" => :catalina
    sha256 "e29903caa80cead8263a21c71a31d60f10e6f0896edb71667cbcbb6924fbe83a" => :mojave
    sha256 "fefdb6338ef48bb69c11996fba8a377027af55bacbf8dcb67dce6c06cf51ec27" => :high_sierra
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
