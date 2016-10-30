class Libfixposix < Formula
  desc "Thin wrapper over POSIX syscalls"
  homepage "https://github.com/sionescu/libfixposix"
  url "https://github.com/sionescu/libfixposix/releases/download/v0.4.1/libfixposix-0.4.1.tar.gz"
  sha256 "38b111111d87f87e5c53a207effb25e5a86b5879770dcd8cf4f38e440620e6d5"

  bottle do
    cellar :any
    sha256 "f9511f4ca3c17903a2aea6e6ed089286cc0d8b8c1f21349a2381bd31acb4fd02" => :sierra
    sha256 "e876af0f5a95391c41f9bf7e7e1ca7c69ba0c5afe4ce570daff34474f3ece1dd" => :el_capitan
    sha256 "defc55272fbda383c8598e216a65b79ba8c5c4fc5c0d0a1752168919f0eee1c7" => :yosemite
    sha256 "f1f7f7248fd249cbb4ac366ad45e313c39055e51ffb0c15679f1b880d5b7a566" => :mavericks
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
