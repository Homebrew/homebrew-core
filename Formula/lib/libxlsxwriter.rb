class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "41b7d307d7b579dada6a007b97b0b74d2e3068e1cf3f8b4a7774421873477215"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/jmcnamara/libxlsxwriter.git", branch: "main"

  bottle do
    manifest_sha256 "785789b6fa5cf56581d30660cee703f6da3a3375e3262b477e4b653088e5b460"
    sha256 cellar: :any, arm64_golden_gate: "1c6c715e373c27c88f5f4d46e553ab0688f10d5560ad6dfca991291b698dc33e"
    sha256 cellar: :any, arm64_tahoe:       "32582d12b4442717cefc82bd5bd1fb8ff5fd2b0be7a7b974cdf3a4f4a9e41f98"
    sha256 cellar: :any, arm64_sequoia:     "47af4a70dd2f59055b185c5a572a24790d4d83c95f012a49ed2d58872cd0f945"
    sha256 cellar: :any, arm64_linux:       "7540a9611a762ca78a41e2e49c7d5294f3a7cf91be31d9cadae2af7b575a1f5c"
    sha256 cellar: :any, x86_64_linux:      "2f2501b1f153287f6f9c128d2e1e133c7182567fa7177d171c3009093359532e"
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
