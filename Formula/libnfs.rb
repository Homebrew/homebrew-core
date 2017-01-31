class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/libnfs-1.11.0.tar.gz"
  sha256 "fc2e45df14d8714ccd07dc2bbe919e45a2e36318bae7f045cbbb883a7854640f"

  bottle do
    cellar :any
    sha256 "fb5bb94ad156100a9dfc77afd9507ea65762da0a198342a838ca485d48a10eab" => :sierra
    sha256 "4906ad802609a739bc2d45237bf21e66470cce0302cfab85752417b53ae07aea" => :el_capitan
    sha256 "4ca6f45a9d7316a4c10d1e1a650db9ba969b4e00450f425b1586b4b6250facee" => :yosemite
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
