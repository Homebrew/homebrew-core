class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.9.9.tar.gz"
  sha256 "bfb8c3bafc12a1191353152c51c75ce95741e7ee50a8ae4afbd8dd6b28c31e95"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    cellar :any
    sha256 "6ee82861b63750f42a46a558b9cb5910332f590a3e44174b66e207e6dd2cdb97" => :catalina
    sha256 "e4c38f89b8cc546709a5500c26616b307a35c59796fd659cba3fa4e427081a3c" => :mojave
    sha256 "0cf3857f418001a0a9fd58b73d405e3ae81407b6ff9282e58dc10b244db0fe4b" => :high_sierra
  end

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
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
