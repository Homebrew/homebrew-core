class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/libnfs-5.0.2.tar.gz"
  sha256 "637e56643b19da9fba98f06847788c4dad308b723156a64748041035dcdf9bd3"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a1a8014854317d7d2cb77e7bdef425ea9ca5555dd0f1ada88326afe6dda189fb"
    sha256 cellar: :any,                 arm64_monterey: "b8df8747861411e30845ca1a6ab42877c74d8ca3e65c838b5ad498faa6609481"
    sha256 cellar: :any,                 arm64_big_sur:  "df45a5d53a8ddd243d7702fbbd834607db180679dd694eb9ef91bf14f1a399f2"
    sha256 cellar: :any,                 ventura:        "586c605f631aefc3ebfaca7f45dace462b7fbcf813a0e9e16992727b4d996f5e"
    sha256 cellar: :any,                 monterey:       "af2b41b3437f4e5e5ead13ff3f3c4fb8cea0aa69813a56199e4d7b0547b6a7bd"
    sha256 cellar: :any,                 big_sur:        "c4fd271ca3189c9fe0509bd7637f6d8c4b9974f47db586de2deb0893bbb4cf68"
    sha256 cellar: :any,                 catalina:       "e188d926e1a762f20c892a5b9202de9c42e2221bc35899a22f5c6a064dac1dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e778214a1e42d82af233ca4ff61fb2cfec684bd9e610c26fc6152e600efd6830"
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
