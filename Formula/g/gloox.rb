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
    sha256 cellar: :any,                 arm64_tahoe:    "5fb8953311b329ddc77cc9b4ca1b0e122788a9741a19adb474df78d34377ae5f"
    sha256 cellar: :any,                 arm64_sequoia:  "d4c45c5c9a56bffba60929aa1a994e8566a971d8c0d7b6a9f2c1d267c5588b62"
    sha256 cellar: :any,                 arm64_sonoma:   "b0c90e096ef2a3ee7b05c264338486bfd6df78666baf363e6b6648078f974b97"
    sha256 cellar: :any,                 arm64_ventura:  "d86499393f8041798c23aac7f224a26161b3099efc7ac7b91a07223be8fb4926"
    sha256 cellar: :any,                 arm64_monterey: "e43969d8fb19e80791a899f36a550dec9e25d9e2555678511176425967540914"
    sha256 cellar: :any,                 sonoma:         "514e1e0c40baa8b06c66e0501fc51b11d5e4cf5960ad13e0ebb76e84151ed461"
    sha256 cellar: :any,                 ventura:        "4f6f5f81d90b12287ab78c7cda2f2d01342e925e9cd0224c9187d681c7023df7"
    sha256 cellar: :any,                 monterey:       "ec49c912e85c4b02f351d6c171d0b93df8387f1883c380e77e187adf98119a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9e5af4334ef24ff8fd701bfda9a221b82388982e1d8fe166d7ee2c30df2954cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95bec00a34c6fa57dd21c50ebeff2a52af273b3a2a413436f40eaeda30b9511d"
  end

  depends_on "pkgconf" => :build
  depends_on "libidn"
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
