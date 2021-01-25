class Libfixposix < Formula
  desc "Thin wrapper over POSIX syscalls"
  homepage "https://github.com/sionescu/libfixposix"
  url "https://github.com/sionescu/libfixposix/archive/v0.4.3.tar.gz"
  sha256 "78fe8bcebf496520ac29b5b65049f5ec1977c6bd956640bdc6d1da6ea04d8504"
  license "BSL-1.0"
  head "https://github.com/sionescu/libfixposix.git"

  bottle do
    cellar :any
    sha256 "a4b0ddb0d3adfce835d9916672a92a9ae7c566e9abedcb602dc4f257b4a9ca5f" => :big_sur
    sha256 "091b714f986845a8c360b666155235dcb2f2b9db2bcdb76734656237135e5b74" => :arm64_big_sur
    sha256 "a87f0db9cf7ac7714d603eb0388127e0a20e1ac7ae1d7b2359de2cea71c330d6" => :catalina
    sha256 "4d8da5161cd9a60d02a086dc3f2a083277cad6a2116689015d9bbaf255eea4e8" => :mojave
    sha256 "eaf5641bda4184e3092f7f2b0c9e61afa120df85df837377ead98de643a7e21e" => :high_sierra
    sha256 "024855892877fd868e04eb8b0d2ef71485ffc48b2f441f88ceb61bcc57a56aea" => :sierra
    sha256 "89a3b36ff587c3eeaa7ba51471ba3d0bc294bdeb66abccd0a3ce446cf6f57e1b" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"mxstemp.c").write <<~EOS
      #include <stdio.h>

      #include <lfp.h>

      int main(void)
      {
          fd_set rset, wset, eset;

          lfp_fd_zero(&rset);
          lfp_fd_zero(&wset);
          lfp_fd_zero(&eset);

          for(unsigned i = 0; i < FD_SETSIZE; i++) {
              if(lfp_fd_isset(i, &rset)) {
                  printf("%d ", i);
              }
          }

          return 0;
      }
    EOS
    system ENV.cc, "mxstemp.c", lib/shared_library("libfixposix"), "-o", "mxstemp"
    system "./mxstemp"
  end
end
