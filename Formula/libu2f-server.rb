class Libu2fServer < Formula
  desc "Server-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-server/"
  url "https://developers.yubico.com/libu2f-server/Releases/libu2f-server-1.1.0.tar.xz"
  sha256 "8dcd3caeacebef6e36a42462039fd035e45fa85653dcb2013f45e15aad49a277"
  revision 2

  bottle do
    cellar :any
    sha256 "4171f31751c8bd489ff38e66de80340f1abff5442472dca02b2b2be5d6bd1b12" => :mojave
    sha256 "8b2986796fde4c4af2ceea03780de6310932f5b26744118d56920694777e0738" => :high_sierra
    sha256 "90ec17a1fccbb6d6ed4e8cd95d6828ef1b0fe80f173435e7124fab938d3af812" => :sierra
    sha256 "566d3f52eef7dca1671f93f8f2b1f351e960b3c98a3737ed7f14843296d5a601" => :el_capitan
  end

  depends_on "check" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl@1.1"

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
