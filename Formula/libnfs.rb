class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/libnfs-1.10.0.tar.gz"
  sha256 "7f6c62a05c7e0f0749f2b13f178a4ed7aaf17bd09e65a10bb147bfe9807da272"

  bottle do
    cellar :any
    sha256 "2a9c7c00a65205e0820806357b31488b0d500718a327fd9449e1ac8b2ceabd8d" => :sierra
    sha256 "a47bed515b9a71a13231c44012314c9c40542dddbe744b9ac42d346076abab52" => :el_capitan
    sha256 "cdad24e1d5f35cf0eaa91fdc5ca073ab2f5fa0662ab8e93aed5561500ad4f25d" => :yosemite
    sha256 "e442efc53a552fde70d4c778cbeb1e5df7400b14a5b9d4f742b7958e7564c6c1" => :mavericks
  end

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <nfsc/libnfs.h>

      int main(void)
      {
        int result = 1;
        struct nfs_context *nfs = NULL;
        nfs = nfs_init_context();

        if (nfs != NULL) {
            result = 0;
            nfs_destroy_context(nfs);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-lnfs", "-o", "test"
    system "./test"
  end
end
