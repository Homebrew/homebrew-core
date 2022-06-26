class Libu2fServer < Formula
  desc "Server-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-server/"
  url "https://developers.yubico.com/libu2f-server/Releases/libu2f-server-1.1.0.tar.xz"
  sha256 "8dcd3caeacebef6e36a42462039fd035e45fa85653dcb2013f45e15aad49a277"
  license "BSD-2-Clause"
  revision 3

  livecheck do
    url "https://developers.yubico.com/libu2f-server/Releases/"
    regex(/href=.*?libu2f-server[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a85f201ad491b24e25e8e3048885e91fec5c47dc00140b609c00100d2fefeb14"
    sha256 cellar: :any,                 arm64_big_sur:  "f1746f86987f50d9ffaf415b51420dba4dab8e64d620c99d63c6c9aed39d524b"
    sha256 cellar: :any,                 monterey:       "de7343ed2a419e8fb63c497d1c8487bdad15261f9d5b07b4cc907f6fd2d106c1"
    sha256 cellar: :any,                 big_sur:        "fa0d80a1f6345e7b7323a837ba5acb031f4728eb674c48a590ae1c3b0a6c3a01"
    sha256 cellar: :any,                 catalina:       "3a5038a64a9820c04a4ad1067ebcf8076936474cc5c18a0d93f7c986adcf0169"
    sha256 cellar: :any,                 mojave:         "a1d26284fa87629ecf5bf965433cd6eeba9eb151e064e22a47ca42a115d5e15c"
    sha256 cellar: :any,                 high_sierra:    "03e06751297ad4aab253d7b1f742fd5c2ad8d79b35836eb132c3c82c20b485e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "508085d21397af83fb5393afe912b5ac8804ee180832ef10dbce5d991889e391"
  end

  depends_on "check" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl@1.1"

  # Compatibility with json-c 0.14. Remove with the next release.
  patch do
    url "https://github.com/Yubico/libu2f-server/commit/f7c4983b31909299c47bf9b2627c84b6bfe225de.patch?full_index=1"
    sha256 "012d1d759604ea80f6075b74dc9c7d8a864e4e5889fb82a222db93a6bd72cd1b"
  end

  def install
    ENV["LIBSSL_LIBS"] = "-lssl -lcrypto -lz"
    ENV["LIBCRYPTO_LIBS"] = "-lcrypto -lz"
    ENV["PKG_CONFIG"] = "#{Formula["pkg-config"].opt_bin}/pkg-config"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <u2f-server/u2f-server.h>
      int main()
      {
        if (u2fs_global_init(U2FS_DEBUG) != U2FS_OK)
        {
          return 1;
        }

        u2fs_ctx_t *ctx;
        if (u2fs_init(&ctx) != U2FS_OK)
        {
          return 1;
        }

        u2fs_done(ctx);
        u2fs_global_done();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lu2f-server"
    system "./test"
  end
end
