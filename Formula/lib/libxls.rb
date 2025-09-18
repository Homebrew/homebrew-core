class Libxls < Formula
  desc "Read binary Excel files from C/C++"
  homepage "https://github.com/libxls/libxls"
  url "https://github.com/libxls/libxls/releases/download/v1.6.3/libxls-1.6.3.tar.gz"
  sha256 "b2fb836ea0b5253a352fb5ca55742e29f06f94f9421c5b8eeccef2e5d43f622c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e400590151f209f52ff66dbd8a11b76f1fb773128b1b6c05e26d93a661b9c011"
    sha256 cellar: :any,                 arm64_sequoia: "abaffb1c9027ca974c12ca4ded7a0b2be05f55cfb7b4ed371a3e14d382278073"
    sha256 cellar: :any,                 arm64_sonoma:  "d90a8a341886453222b61a6fc9015797f5b3b517620f7f4fa5ec217364bf1896"
    sha256 cellar: :any,                 arm64_ventura: "d265631b00cebb4c0afc5dce7e1aa31c332e50022b1b3718acdb10bc68639021"
    sha256 cellar: :any,                 sonoma:        "dfbc41b4db8cb154d168ccd41d8a730400fd49b73239cb6fc1d2b1ef15b80e96"
    sha256 cellar: :any,                 ventura:       "6ba571cf05be33a069621adc5e455983a26ce132f55bbee5ed2b3b6cab98cde7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773ca56b2f5b6b529843780b77ebcb600a813970eaedeb0a07cdac45fa8b8d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af8e8be72b0f2317a9901db68e14b77595d48da2294df10ef3aafc2aeaa9df02"
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
