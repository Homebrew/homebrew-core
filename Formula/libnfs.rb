class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/libnfs-5.0.1.tar.gz"
  sha256 "7ef445410b42f36b9bad426608b53ccb9ccca4101e545c383f564c11db672ca8"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bdab2c6de645fcf6e0ece45ed381adebfa405cc701761f5adeba226ee6182cdf"
    sha256 cellar: :any,                 arm64_big_sur:  "5a900ac4f000b73468fd88c42cf22b88667e35c7779882ed28e7b5a1a58a0470"
    sha256 cellar: :any,                 monterey:       "24ff50f0aefaa107331ad6b39efeb116e593a64ee0d356e44dbc15396f65f423"
    sha256 cellar: :any,                 big_sur:        "5d81d54212057e9c3a54cf64e8184c9d822e034b3e166db675f4ce1c7c13ef49"
    sha256 cellar: :any,                 catalina:       "0bc064e523d4f3d95cce9a4345b3de6a30df452f7b7a084bf6fcbd75a9dce5a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d4c269f24baba63e66645fe0fe99ddf60487c258d7623357b5242ed76b897f"
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
      #if defined(__linux__)
      # include <sys/time.h>
      #endif
      #include <stddef.h>
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
