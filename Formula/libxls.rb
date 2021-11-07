class Libxls < Formula
  desc "Read binary Excel files from C/C++"
  homepage "https://github.com/libxls/libxls"
  url "https://github.com/libxls/libxls/releases/download/v1.6.2/libxls-1.6.2.tar.gz"
  sha256 "5dacc34d94bf2115926c80c6fb69e4e7bd2ed6403d51cff49041a94172f5e371"
  license "BSD-2-Clause"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--program-prefix=lib"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <ctype.h>
      #include <xls.h>

      int main(int argc, char *argv[])
      {
          xlsWorkBook* pWB;
          xls_error_t code = LIBXLS_OK;
          pWB = xls_open_file(argv[1],"UTF-8", &code);
          if (pWB == NULL) {
              return 1;
          }
          if (code != LIBXLS_OK) {
              return 2;
          }
          if (pWB->sheets.count != 3) {
              return 3;
          }
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsreader", "-o", "test"
    system "./test"
  end
end
