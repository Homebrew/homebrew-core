class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.1.3.tar.gz"
  sha256 "bd7a3d38c6a8ef5e31d07a61fded23ac00d29d758417ca42db89da60bf796d78"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4b4200a7b2e47e47950fa0bbcc8cd4077d77fa87111748d3678131cb75076101"
    sha256 cellar: :any,                 big_sur:       "4b192018717f4a5fd672d6a6cf09905cdb4b4a4c5198196c3cbdc2954e8bec85"
    sha256 cellar: :any,                 catalina:      "bd604f87a226a319a53949e29220c554b5f828c97ce0fb3018da4ae8e3435f8d"
    sha256 cellar: :any,                 mojave:        "0c989d84960966f333403b33eeb1d86c21cfd8abd4e14de75ad65382e39c4e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "185c8e29c1df2afbdd53b98deae0ebe7971b5630b719d0c2e5d6774557241a63"
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
