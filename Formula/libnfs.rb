class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/libnfs-2.0.0.tar.gz"
  sha256 "7ea6cd8fa6c461d01091e584d424d28e137d23ff4b65b95d01a3fd0ef95d120e"

  bottle do
    cellar :any
    sha256 "fad6dded94a8ad815f99ce5df0116c30798ed30f3dd67272742c61183a15f6f1" => :sierra
    sha256 "507e2c7199d82a3c057f95f4ccb9210f04e00e43881b5807186d9641edfc9bd3" => :el_capitan
    sha256 "e83eac3ac327b5e4da5e6d7aa39668ce7067ee0fa8cab04023f268339977ee1e" => :yosemite
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
