class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.1.3.tar.gz"
  sha256 "bd7a3d38c6a8ef5e31d07a61fded23ac00d29d758417ca42db89da60bf796d78"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "104694c2568fd1d7463f9fa767a655f82e2d6078b774cde984ed3fc8fcaa2053"
    sha256 cellar: :any,                 big_sur:       "0bf43f5e1b2d840f03f8c14e72f09d4be44ad4a1cfd4f9a96db13cbb15c28f2b"
    sha256 cellar: :any,                 catalina:      "99fcb1f9ba72846cc9d2769d25e1ac949a7e2be99756b68a46e49f19bcfbbecc"
    sha256 cellar: :any,                 mojave:        "7932b43040ead3228bd9077da6608fa92f6408c4355dcc378cc60c5c6bbe64ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887cfbc2b54d1deadff692a448a1ce81d2f8e5d908faf89b973eb8ff92c25069"
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
