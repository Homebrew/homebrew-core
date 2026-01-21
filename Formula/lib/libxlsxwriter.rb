class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "e0db59fc248a5ffa465a05ea83a9d466d4bca0e53ab42771515d4ebb467a41c1"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f03b11c3707bd8f026103c26689aedba1899193a4e0d913fe1d9053742ebca3"
    sha256 cellar: :any,                 arm64_sequoia: "1f88c6e5f8ed5093b94425ec4302999dd62326a9e7ac089e11a320193beaeb92"
    sha256 cellar: :any,                 arm64_sonoma:  "a9a4881f4b1ef10c6c0dfa0c94289fc57c90a92a4307ccd6ce71a14b02c2b4bc"
    sha256 cellar: :any,                 sonoma:        "c69b967e9b46e3cd04938667bed6f6db5c6cc69ebb72de63f093596db2ce0015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fe77a9d57639fc2d4011ce10bb7feecdaaefd412fb9d3fb977c3ba0cf6089b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9027a97c4824def33c88d47e7460a60104bca5e9c27e12c5fa2c06ca93bc86b6"
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
