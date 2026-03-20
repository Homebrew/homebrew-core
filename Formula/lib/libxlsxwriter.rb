class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "e0db59fc248a5ffa465a05ea83a9d466d4bca0e53ab42771515d4ebb467a41c1"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c5270d39abf4b98ae78add1ceb9251066b8fcb804cdc3f379ade7689e37521a8"
    sha256 cellar: :any,                 arm64_sequoia: "6761b53a60a8b03860510381371b0c6841e4ca4b77ba5705c81172b2a0b6cefb"
    sha256 cellar: :any,                 arm64_sonoma:  "3e9ecb49f206268f647c4c48f01008d5ba7ab9dbfd5695dba05f35993b90e318"
    sha256 cellar: :any,                 sonoma:        "d925e1ecb73f059f5ad8d53ed6f2e9f90b4ad32d9c34042b6500fea6368c4e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af3be196f27cb7c63a3755ff38f1f20a51cdf88b02d83503381c38eecbde32e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0178462a88fe85971f75fee9a92b90939594ee9c839e0dfab6e2b4e7c02edf7a"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "xlsxwriter.h"

      int main() {
          lxw_workbook  *workbook  = workbook_new("myexcel.xlsx");
          lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
          int row = 0;
          int col = 0;

          worksheet_write_string(worksheet, row, col, "Hello me!", NULL);

          return workbook_close(workbook);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxwriter", "-o", "test"
    system "./test"
    assert_path_exists testpath/"myexcel.xlsx", "Failed to create xlsx file"
  end
end
