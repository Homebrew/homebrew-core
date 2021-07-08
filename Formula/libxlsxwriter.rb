class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.0.9.tar.gz"
  sha256 "bb08c87838fc562a1e3cb3be16ad2c764d56bd309011042beab50ebf9d960487"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b24239371e3016003b7fefea422ce3d2dd1747657857c808bbfcf56654c6c3e8"
    sha256 cellar: :any, big_sur:       "299b869885d640cf1185a32976611e3ab37cd09e4d7be58ff71e5f2279251703"
    sha256 cellar: :any, catalina:      "aa40933699f35aefabf4a5ef3f20d346512e03a1d9cbc262475a97871c855014"
    sha256 cellar: :any, mojave:        "6b9ca979929ee06f76aad98d05704f9a16fa618799669f5021d75296a55818d0"
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
