class Libxls < Formula
  desc "Read binary Excel files from C/C++"
  homepage "https://github.com/libxls/libxls"
  url "https://github.com/libxls/libxls/releases/download/v1.6.4/libxls-1.6.4.tar.gz"
  sha256 "064ee1da6cf3d481d8af4a936e0e0ce0190114e468fb7dfef5a81610746081e0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8106160b907bc71a2d8361d482dffc72ff2d24e71ce3a914fb987cf6c5a00520"
    sha256 cellar: :any, arm64_tahoe:       "e2ec987b75932f475d9256392b5e38ecde92bbea2bf01697db2e34d08a8b27fc"
    sha256 cellar: :any, arm64_sequoia:     "ad42d9a4494d04a1e24edacc3944873062f12261169351844dd904570e61ee0c"
    sha256 cellar: :any, arm64_linux:       "4f7fc830cd655200ff7f155014357798d24dd92734ccc98c6b26f64c900f6a58"
    sha256 cellar: :any, x86_64_linux:      "9cb179bee11e0651c57cd2706d27365c74ed895cf7a7dad4c6fa3ba088770408"
  end

  def install
    # Add program prefix `lib` to prevent conflict with another Unix tool `xls2csv`.
    # Arch and Fedora do the same.
    system "./configure", "--disable-silent-rules", "--program-prefix=lib", *std_configure_args
    system "make", "install"
    pkgshare.install "test/files/test2.xls"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <ctype.h>
      #include <xls.h>

      int main(int argc, char *argv[])
      {
          xlsWorkBook* pWB;
          xls_error_t code = LIBXLS_OK;
          pWB = xls_open_file(argv[1], "UTF-8", &code);
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
    C

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsreader", "-o", "test"
    system "./test", pkgshare/"test2.xls"
  end
end
