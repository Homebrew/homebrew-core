class Libu2fServer < Formula
  desc "Server-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-server/"
  url "https://developers.yubico.com/libu2f-server/Releases/libu2f-server-1.1.0.tar.xz"
  sha256 "8dcd3caeacebef6e36a42462039fd035e45fa85653dcb2013f45e15aad49a277"
  revision 2

  bottle do
    cellar :any
    sha256 "732660807115af952d552524130daa4bf0e4314eebf2f94eade5e2b8229ad678" => :mojave
    sha256 "f947cf956060d05e1ccf80d21e5f8e0efcc26144cdc15998fb26235bde0b184c" => :high_sierra
    sha256 "e507b37b71477f7315eeae089473689bc6fbf05466a402ffd48df80c26985ddd" => :sierra
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
