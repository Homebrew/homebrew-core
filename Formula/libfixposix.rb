class Libfixposix < Formula
  desc "Thin wrapper over POSIX syscalls"
  homepage "https://github.com/sionescu/libfixposix"
  url "https://github.com/sionescu/libfixposix/archive/v0.4.0.tar.gz"
  sha256 "c8625ccb6c661ae786c3070b7b034c97c5ffd12851a9e06255df376d3071ded8"
  head "https://github.com/sionescu/libfixposix.git"

  bottle do
    cellar :any
    sha256 "3ae13b2d95342af1b29c0d147673baf94a57c64736be1d59d7cb08730be630df" => :el_capitan
    sha256 "f0ccf27d4002393ac6e95b4cce9a76a12321f640e89f10520218e2f60f6a77dc" => :yosemite
    sha256 "cc623212cd334aeb63d849b0cb73a6c5ec50b7b7569c64ebfd65834ffb2bb9f9" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
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
    system ENV.cc, "mxstemp.c", lib/"libfixposix.dylib", "-I#{include}", "-L#{lib}", "-o", "mxstemp"
    system "./mxstemp"
  end
end
