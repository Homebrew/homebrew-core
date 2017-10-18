class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.7.5.tar.gz"
  sha256 "9b57d9cc989e552e4ac6366b7bac0950aeab0bc7032a8c18a5d5b33132f0de9c"

  bottle do
    cellar :any
    sha256 "2cb7f5f3b0fa7daed72cfb07d194bdd3c10ac155152a04318f70b0fb46b8653a" => :high_sierra
    sha256 "828ee4b19a012a9b10e41a406acd6ea9e0d7800588473e0076e205dfa13693ee" => :sierra
    sha256 "59d333f5aa5d67cc5f35be87133a43e344d094aea64b96c1879dbdd463187ec8" => :el_capitan
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
