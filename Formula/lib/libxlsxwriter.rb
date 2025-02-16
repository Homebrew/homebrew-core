class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "242821862d5841e68ce9b0d7c774cd3b2c9136bb684a2b0c26cea9447cc31ff3"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0c544fb8d5ebd9156cafa4d34260d31a85385449200c3ad715a8e82255de653"
    sha256 cellar: :any,                 arm64_sonoma:  "5146c64ded6a518fdb65c65921fa9177adbfcf02c1c2afc0bc165a161341b4ed"
    sha256 cellar: :any,                 arm64_ventura: "3ba9c1eb798bca58a7580d208c5a5990323185639449ffe550ff73dfe95a2907"
    sha256 cellar: :any,                 sonoma:        "19f5a3386d69981572a0c0b49d47d4ea85399ddd44abcc39fde9ae5c0c9c7289"
    sha256 cellar: :any,                 ventura:       "ccd43296c8d90b562a0732721967d317f81efa391768550062fb0047db369830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "873367fb88babfc34ead224e216d2ade9e43a59af0e5ef1a6cabb38f226834a8"
  end

  uses_from_macos "zlib"

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
