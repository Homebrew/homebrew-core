class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.28.tar.bz2"
  sha256 "591bd12c249ede0b50a1ef6b99ac0de8ef9c1ba4fd2e186f97a740215cc5966c"
  license "GPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/Latest stable version.*?href=.*?gloox[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1818e6a640fd72abca657dee0f7dd846408f5f7854723c9a98d6c7c776f8a0f9"
    sha256 cellar: :any,                 arm64_sequoia: "1d26a13f01fec261432f2dae041b41202cb9f6a89a8645620f4130594720350b"
    sha256 cellar: :any,                 arm64_sonoma:  "4259b10f32c5131583820cc76e3d8e0f11ee1d75108d69e1198957530429ee7d"
    sha256 cellar: :any,                 sonoma:        "a91156a42c6e11a6e4ee53e5ae6afd651a986ebca33cbfcce0b8dc447d9e265e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99fb4b6444c8f11419eed45d4d29df4919b9d1c35e75615b787fc1de9269feaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc2eb3e53975d18eaebb6bf9e34fb002a68420432d36e53f709e1d94446a7d2d"
  end

  depends_on "pkgconf" => :build
  depends_on "libidn"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix build issue with `{ 0 }`, build patch sent to upstream author
  patch :DATA

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-zlib",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-tests",
                          "--without-examples",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end

__END__
diff --git a/src/tlsopensslclient.cpp b/src/tlsopensslclient.cpp
index ca18096..52322b1 100644
--- a/src/tlsopensslclient.cpp
+++ b/src/tlsopensslclient.cpp
@@ -51,7 +51,11 @@ namespace gloox
     {
       unsigned char buf[32];
       const char* const label = "EXPORTER-Channel-Binding";
-      SSL_export_keying_material( m_ssl, buf, 32, label, strlen( label ), { 0 }, 1, 0 );
+
+      unsigned char context[] = {0}; // Context initialized to zero
+      size_t context_len = sizeof(context); // Length of the context
+
+      SSL_export_keying_material(m_ssl, buf, 32, label, strlen(label), context, context_len, 0);
       return std::string( reinterpret_cast<char* const>( buf ), 32 );
     }
     else
