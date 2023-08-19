class Libxls < Formula
  desc "Read binary Excel files from C/C++"
  homepage "https://github.com/libxls/libxls"
  url "https://github.com/libxls/libxls/releases/download/v1.6.2/libxls-1.6.2.tar.gz"
  sha256 "5dacc34d94bf2115926c80c6fb69e4e7bd2ed6403d51cff49041a94172f5e371"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5dbc5a3cc52e9f6b52bfe3c1f065b687ce7596fcd30b75ca0ba6ad55613d878d"
    sha256 cellar: :any,                 arm64_monterey: "fdcf6a5152977cad6b6cd2e9098fa656a77a082e1bd33de0688aaab7a1a7ab7e"
    sha256 cellar: :any,                 arm64_big_sur:  "7d39e15d8683c700347ab81d920698354cc96d195b64e8483784e6cac36b75fa"
    sha256 cellar: :any,                 ventura:        "f11fa55a4772754f5acb3d6915d6ac2b934ef07592fe6057cdedb6fb212c08ad"
    sha256 cellar: :any,                 monterey:       "ae68097132fde8b5fe81d0f251184d450930765e52aa64565923295dfe1288aa"
    sha256 cellar: :any,                 big_sur:        "a00c9704817ff786484d2da807aaf5ba39bfc2ce1c79370830cdbe62e7ac706d"
    sha256 cellar: :any,                 catalina:       "2081f2f715405c37ac444e89377033c06bd922d04d04c63db93e01aa9222827d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9fa950062d66333e82b1d7dd146251d070a13f2e66367cd7ddee7ecc811b7b1"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Add program prefix `lib` to prevent conflict with another Unix tool `xls2csv`.
    # Arch and Fedora do the same.
    system "./configure", *std_configure_args, "--disable-silent-rules", "--program-prefix=lib"
    system "make", "install"
    pkgshare.install "test/files/test2.xls"
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
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsreader", "-o", "test"
    system "./test", pkgshare/"test2.xls"
  end
end
