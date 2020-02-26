class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.9.4.tar.gz"
  sha256 "6fbc4d3f84255debbce1ce024087074b7c3f01856115e8bf6b0354db77d3c3df"

  bottle do
    cellar :any
    sha256 "558eb6ce5846aa01765d61c18ef5c25e0047c49a0f05ec8b388e6a13c464d9cc" => :catalina
    sha256 "83efeb83716f6330e4ce0ace9c029b261659c373cce9a6c1798a66a69ef0b7a4" => :mojave
    sha256 "52c8e1f318f0faebfd5bb5d9fb99fdb00e38e3239d07115f82755deecb9016e4" => :high_sierra
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
