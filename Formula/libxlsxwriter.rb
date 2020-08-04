class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.9.5.tar.gz"
  sha256 "a42daf9a96a5ba24d46a56bd0ad0d44bc4bc35f73b8aed22c4fa5f8f3e8eb8be"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "aa4dfa3809039590f7e5284ab4ea0457d351d7b5983ec7f3ff62a944d1e0392c" => :catalina
    sha256 "71bfed5e6a4a29cfc504ca53036555a642da48e7768e0a7520ee7e4835f919dd" => :mojave
    sha256 "e0a34105b51af1ee4ff32a5e8bbbb9fd853b19b3d860c79396d583834ec8708f" => :high_sierra
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
