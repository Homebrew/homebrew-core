class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "122c98353e5b69284a1cd782be7ae67bdefde2146f8197ef89a1aaf886058e86"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f55b9c617fe25a94a1b03bf58e46426f17c80c7f068a1752c83e5c98cba44677"
    sha256 cellar: :any,                 arm64_sonoma:   "c568844ace62206789e83e4a830585e8fd58693af29449d379ea1c091a0e8269"
    sha256 cellar: :any,                 arm64_ventura:  "20fa57cbd5a71882f7df98b124487a5ed57c37d99a0a179ac580e3b927d5f127"
    sha256 cellar: :any,                 arm64_monterey: "2507eee99de1d3df0a1f0b05892a48a7ba10824a9b36dee7633d1ff3e0c6e754"
    sha256 cellar: :any,                 sonoma:         "de23ba0e92ed60dadf900aae94aa07712d18f90616b381cca14dafb2d85c2d28"
    sha256 cellar: :any,                 ventura:        "f1cefac3d915ec12277021d41062423d08455574528c47417cd25ed396ac9ba9"
    sha256 cellar: :any,                 monterey:       "49d93fcec0c09fbe36c522758e9156ac338ba2e1de1a70c3585cf2a0938f38c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff137185d193bf13fb093c30db484fccbb1a34fa79108a82d9dd3db18957657e"
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
