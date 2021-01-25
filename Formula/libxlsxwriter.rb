class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.0.0.tar.gz"
  sha256 "8b353379333c323d14a9d265cd2491d3a6c0032c8d6ec2141f10b82ab66a087c"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    cellar :any
    sha256 "f79e6842a397bc0da3208dfeb133784caac0d9ee14b7ba1f20f1e377fc54ea26" => :big_sur
    sha256 "7d53786b313a6ed4f6b4e0e8781f511f39e815b1fd52e7a6731dc4273802295c" => :arm64_big_sur
    sha256 "193e7a0b38a21425d0c5a9cf72a13f9c6baafe09072056eb521ae46ffcff43ab" => :catalina
    sha256 "1674a7100e0ce0823b907ca07b3c5834dc9ff9f2b57b6da5cc71d5b09a07dd51" => :mojave
    sha256 "6ed35324d633aef69f2493c7bede7729cadadcce9c60149ee28f1326a1da8bd7" => :high_sierra
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
