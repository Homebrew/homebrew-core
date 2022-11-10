class Libfixposix < Formula
  desc "Thin wrapper over POSIX syscalls"
  homepage "https://github.com/sionescu/libfixposix"
  url "https://github.com/sionescu/libfixposix/archive/v0.5.0.tar.gz"
  sha256 "7c829a8270b984eed9af03735581317882320d454ba94a0cc955543a140e280d"
  license "BSL-1.0"
  head "https://github.com/sionescu/libfixposix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "afb2472ba3bbedae7efd41fc65826cdaec11cc9642f8bd247ba0df4fc7f8e182"
    sha256 cellar: :any,                 arm64_big_sur:  "1d088514a4e32afecb4ca2b432647be4b9c1a187143ad3b253ae90e1669f9162"
    sha256 cellar: :any,                 monterey:       "133344bce2b08648f1e12f36516d072ad73426b26e75684c2cfd64c5191dbdb1"
    sha256 cellar: :any,                 big_sur:        "a2a45d8b608f8fefb4bb76a60cda4c35063c8d9e3359ebf34ac8acb15d5977f7"
    sha256 cellar: :any,                 catalina:       "630b3903ceb35f8d256d0fc661466956cac7ac1b363c8eafe71726b921b9c7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dfa68207fc6737bd310472cbc62d305d283e980a582396a20e88ff7c3118787"
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
