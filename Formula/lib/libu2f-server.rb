class Libu2fServer < Formula
  desc "Server-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-server/"
  url "https://developers.yubico.com/libu2f-server/Releases/libu2f-server-1.1.0.tar.xz"
  sha256 "8dcd3caeacebef6e36a42462039fd035e45fa85653dcb2013f45e15aad49a277"
  license "BSD-2-Clause"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "59f0515b756b791b09d679388ad5c7b43a9f0f00b9f58d7132811aa236ca0be3"
    sha256 cellar: :any, arm64_tahoe:       "a76f87a11f1a8f488d21d4d3669f70113665921bdd469875dd13b4ce5aec3bb8"
    sha256 cellar: :any, arm64_sequoia:     "6314feddac6c047aaf6e5225c275a1908e39c162685b45c39be866dca77091e3"
    sha256 cellar: :any, arm64_linux:       "71ea095fbe97fd0ac32de3c95907d20012a8ecdb2a9a09c925c1c6c8e6546011"
    sha256 cellar: :any, x86_64_linux:      "e5cd37fc774c251bd110b13f832a5a34b39b82ff062eda33020712770d6ab6bf"
  end

  # https://www.yubico.com/support/terms-conditions/yubico-end-of-life-policy/eol-products/
  deprecate! date: "2025-11-22", because: :unmaintained, replacement_formula: "libfido2"
  disable! date: "2026-11-22", because: :unmaintained, replacement_formula: "libfido2"

  depends_on "check" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"
  depends_on "openssl@4"

  # Compatibility with json-c 0.14. Remove with the next release.
  patch do
    url "https://github.com/Yubico/libu2f-server/commit/f7c4983b31909299c47bf9b2627c84b6bfe225de.patch?full_index=1"
    sha256 "012d1d759604ea80f6075b74dc9c7d8a864e4e5889fb82a222db93a6bd72cd1b"
    type :backport
    resolves "https://github.com/Yubico/libu2f-server/pull/42"
  end

  deny_network_access!

  def install
    ENV["LIBSSL_LIBS"] = "-lssl -lcrypto -lz"
    ENV["LIBCRYPTO_LIBS"] = "-lcrypto -lz"
    ENV["PKG_CONFIG"] = "#{formula_opt_bin("pkgconf")}/pkg-config"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lu2f-server"
    system "./test"
  end
end
