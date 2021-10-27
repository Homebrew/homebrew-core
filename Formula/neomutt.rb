class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20211022.tar.gz"
  sha256 "49aa5029665c6819e708276b9efa1ca71ec5afe870eb9f08e656107d234941e6"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "d120a26ccf7566d068226b52c07040ad63364ccf5ffd9b69dbbc550d4966393b"
    sha256 big_sur:       "98e1898da2c59d05bd043fd6b643b9a9b0ba9566acd7fa43e302b551463de7ed"
    sha256 catalina:      "5f850eac5db2ea581b7b69db0bd1e28198fb483cb7c1a991e2448696b48354de"
    sha256 x86_64_linux:  "b64849b42fd3b87dcec7c0db4393c2e8b024938fd0d947acc10bcbf78558ea58"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --prefix=#{prefix}
      --gss
      --disable-idn
      --idn2
      --lmdb
      --notmuch
      --sasl
      --tokyocabinet
      --with-gpgme=#{Formula["gpgme"].opt_prefix}
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-ui=ncurses
    ]

    args << "--pkgconf" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
