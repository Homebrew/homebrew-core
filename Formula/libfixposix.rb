class Libfixposix < Formula
  desc "Thin wrapper over POSIX syscalls"
  homepage "https://github.com/sionescu/libfixposix"
  url "https://github.com/sionescu/libfixposix/releases/download/v0.4.1/libfixposix-0.4.1.tar.gz"
  sha256 "38b111111d87f87e5c53a207effb25e5a86b5879770dcd8cf4f38e440620e6d5"

  bottle do
    cellar :any
    sha256 "3ae13b2d95342af1b29c0d147673baf94a57c64736be1d59d7cb08730be630df" => :el_capitan
    sha256 "f0ccf27d4002393ac6e95b4cce9a76a12321f640e89f10520218e2f60f6a77dc" => :yosemite
    sha256 "cc623212cd334aeb63d849b0cb73a6c5ec50b7b7569c64ebfd65834ffb2bb9f9" => :mavericks
  end

  head do
    url "https://github.com/sionescu/libfixposix.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"mxstemp.c").write <<-EOS.undent
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
    system ENV.cc, "mxstemp.c", lib/"libfixposix.dylib", "-o", "mxstemp"
    system "./mxstemp"
  end
end
