class Libu2fServer < Formula
  desc "Server-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-server/"
  url "https://developers.yubico.com/libu2f-server/Releases/libu2f-server-1.1.0.tar.xz"
  sha256 "8dcd3caeacebef6e36a42462039fd035e45fa85653dcb2013f45e15aad49a277"

  bottle do
    cellar :any
    sha256 "222f72a76779545285dcd280b9773cca284f617c58e38454c3f19fd514241648" => :high_sierra
    sha256 "87859895f46a6e196deaa704cac54d0ebc003dfd6c6a0d47d5319dfc0f3b9e59" => :sierra
    sha256 "9a5704c78fa45d5e72e6fdb55656cdc49cda37fe56fc6c3a3669390dd6ef883e" => :el_capitan
    sha256 "b6e45ad28814759b052657a14884f5754e65decdcd8fa185fe59382ca30d5e75" => :yosemite
    sha256 "53cf2a8cb039a27cc4b36605245b15aee85f8d1044f3ba49cb12868ccf0b0cdf" => :mavericks
  end

  depends_on "check" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl"

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
