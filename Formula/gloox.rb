class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.23.tar.bz2"
  sha256 "97cb6a0c07e320ffa4a7c66e8ab06b2361086271dc87ed2398befef4e8435f8a"

  bottle do
    cellar :any
    sha256 "ae614fa73c886d568e4bb6916438affd3b081bccfc4904fef4a4110417f41e9d" => :catalina
    sha256 "eea355a755180f72c719f06d0eae5c7b03223c35f39aae6379a007f0a6333ffe" => :mojave
    sha256 "730858e264fc531556d60fd93f971614e9ce22ee1db1391f651a8fba2b257198" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-zlib",
                          "--disable-debug",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
