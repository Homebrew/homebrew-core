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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3ee5815ba1a374c9a85206466bd83b20f5de894ede219927281bf17cf4a1f415"
    sha256 cellar: :any,                 arm64_monterey: "78d60a35c880f7f993f07eb38dc6d1944082ca6325d88c6ee4f22a34fe9cb50f"
    sha256 cellar: :any,                 arm64_big_sur:  "8e294e52f4bc809affacf5a39d61eda94851600d345c946c942bbeda202dc607"
    sha256 cellar: :any,                 ventura:        "e69be1150f198f72d7ed21bef98e94ae97eb893b68d09cd09b0f8673f5b800e6"
    sha256 cellar: :any,                 monterey:       "d45bdb7ea77081757ae316157db4dea008f06a2998345f6e3c64c98f46830535"
    sha256 cellar: :any,                 big_sur:        "f22956d7adce96f3e73bf0e6584f864f2f2aec7137398f5e6a151965f30655fd"
    sha256 cellar: :any,                 catalina:       "33ecd6fbd1b611fec3ef7cdf3aeb90ddfce9be4cfb70211add5540faa79556ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e4dfb9db89bfc5720aba123638286a77d5d76d9bb108a1bf7b2c1bf01ffa6e"
  end

  depends_on "check" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl@3"

  # Compatibility with json-c 0.14. Remove with the next release.
  patch do
    url "https://github.com/Yubico/libu2f-server/commit/f7c4983b31909299c47bf9b2627c84b6bfe225de.patch?full_index=1"
    sha256 "012d1d759604ea80f6075b74dc9c7d8a864e4e5889fb82a222db93a6bd72cd1b"
  end

  def install
    ENV["LIBSSL_LIBS"] = "-lssl -lcrypto -lz"
    ENV["LIBCRYPTO_LIBS"] = "-lcrypto -lz"
    ENV["PKG_CONFIG"] = "#{Formula["pkg-config"].opt_bin}/pkg-config"

    system "./configure", *std_configure_args, "--disable-silent-rules"
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
