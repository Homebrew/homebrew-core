class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "03ae330d50f74c8a70be0b06b52bd50868f7cd1251ed040fe3b68d1ad6fd11dc"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b280205134eaf3fe3e68ce2ce3cded36e004b6f62631967261e168b4731084b8"
    sha256 cellar: :any,                 arm64_sonoma:  "bef02f42df7748a43b1448997506be2f36e31655bdccfde2a750c2c283e8677f"
    sha256 cellar: :any,                 arm64_ventura: "6f119440dbbc4144c1a2f6e110fea9e6d197a1d758046864e7794e3ee9e21073"
    sha256 cellar: :any,                 sonoma:        "680953124eb8cfa063c79d095ea0e5789c3dc912b09b13d11e126f53c2bfaee5"
    sha256 cellar: :any,                 ventura:       "d136ee61c5a24da5e728625c44f0ba9bf5f35e6e030c529f21da6e0433bdab8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1186d8d949a1673eac903322330644875f4bc908aa7c85566ad3ba22406c5a9"
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
    assert_predicate testpath/"myexcel.xlsx", :exist?, "Failed to create xlsx file"
  end
end
