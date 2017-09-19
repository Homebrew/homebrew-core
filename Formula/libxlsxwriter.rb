class Libxlsxwriter < Formula
  desc "C library for creating Excel XLSX files"
  homepage "https://libxlsxwriter.github.io/"
  url "https://github.com/jmcnamara/libxlsxwriter/archive/RELEASE_0.7.4.tar.gz"
  sha256 "4a1143e4d9532468305fe7553792ab01274febdf715175a89c7ab8296378fa14"

  bottle do
    cellar :any
    sha256 "15153f38c077401e53768c7613d58599bc1f744d9891507063ffcef8184a0803" => :high_sierra
    sha256 "a0ad27b0aaaf650c15eca6115e7559ceaf3d75b4d16cbc29ed58672608200859" => :sierra
    sha256 "8e3a337398602bf37e5100e95613a5ab7f300c341c5ee72271402e3eb22b9481" => :el_capitan
    sha256 "378013e1ca6dabf13e069c61ed997a5ca07264f31ef5ad65dae9e267ff98737e" => :yosemite
  end

  def install
    system "make", "install", "INSTALL_DIR=#{prefix}", "V=1"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
