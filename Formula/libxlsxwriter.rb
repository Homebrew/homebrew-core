class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_1.1.0.tar.gz"
  sha256 "c74e6bed66158aaf86b2d624243c6d89cdbbbca406258ab5ef0d55e71381773e"
  license "BSD-2-Clause"
  head "https://github.com/jmcnamara/libxlsxwriter.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "48d9d1b702787ead62640bf532ae82797461c05ce7d567130c57584a63404a03"
    sha256 cellar: :any,                 big_sur:       "88cc8a236de72dc7a6148e82a25c15178f3d553544e5c7bd1b8ca49097f1eb68"
    sha256 cellar: :any,                 catalina:      "4e0924b586cea2540dc77747b70cea11213fea4ffa0003f603c4ec31f29d7b68"
    sha256 cellar: :any,                 mojave:        "6db9d2b2e0088e5359c5783092ed9ace2b7aee5a9d8e21b09f2c360c3fddbc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4be871009b3f62bef93e446d894c4ffccf9b1369d6c27b0fb534f0b9e40c6b2c"
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
