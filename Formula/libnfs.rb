class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/libnfs-4.0.0.tar.gz"
  sha256 "6ee77e9fe220e2d3e3b1f53cfea04fb319828cc7dbb97dd9df09e46e901d797d"

  bottle do
    cellar :any
    sha256 "d727464baa3bbd6111f7b791ae67da3573e47be5d7d613c314853e581743f941" => :catalina
    sha256 "e51a653f469f19db8c24f009166b7c63a3d9e48ffd16e687d81e2fc0da52f632" => :mojave
    sha256 "2c6199b4295a952c6c179811c9190c8741054011f23ed5a051528baf07b44509" => :high_sierra
    sha256 "668a6d77334fd656ea8ca32c1bb36c9253fb95f1dc701607d722afa6af6aa737" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    system ENV.cc, "test.c", "-L#{lib}", "-lnfs", "-o", "test"
    system "./test"
  end
end
