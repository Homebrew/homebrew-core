class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.1.5.tar.gz"
  sha256 "12843587d591cf679e6ec63ecc629245befec2951736804a837696cdb5d61946"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af227826caecade95706ed808c915c0491e41c3a530583f8f5e44b031521d5d4"
    sha256 cellar: :any,                 arm64_monterey: "720f746cd873de406ad3ea9ab632ddcf0c29121776aa5fe7b692ffd209e7c999"
    sha256 cellar: :any,                 arm64_big_sur:  "4b9c76ab2fecc1335accfcbd3d0139f3d318c5e2c7230dfd2732681e4f59ace0"
    sha256 cellar: :any,                 ventura:        "99a222cd01b4dfc883e86289c76379f3e08f070630df45442e8297c17e53327c"
    sha256 cellar: :any,                 monterey:       "8223c8847c8d0799381165387ce7e999c8651b655ebe025a3f617d0ff6db11e2"
    sha256 cellar: :any,                 big_sur:        "7dcd601f57c94ac878c06cd247f7d25130b9618ef9ed72b1efd1bf5973b107a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1565e3f517d9a96aa04aa572d1152dc1838a083c55a3126e7d5b6d169aff87dd"
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
