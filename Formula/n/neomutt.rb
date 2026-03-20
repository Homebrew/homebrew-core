class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20260105.tar.gz"
  sha256 "a78e55a0df62b7f98566676d0ab9041aad89b2384bb5c6f3a96302a5cf49968d"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "1f42abf2fdac462a7ce9c5d41f4c23333413e4bf345da91be3d9c14ae88166ef"
    sha256 arm64_sequoia: "1e4576c99e49169de00329f586b361dffa469a3a4147f93cc785e8f21b71d159"
    sha256 arm64_sonoma:  "9d799a1ee87b0674ad951cd186a3c1112936f1e8cdd3f83cf16e4d85c28f943b"
    sha256 sonoma:        "f64a616c6efaf6506c72782eee4a690731afc8d74da4333c206a45877155f37a"
    sha256 arm64_linux:   "e990060d151f3c6f4c99bc0b52b22b9735d39e1f619c1449d0c909ca3849a526"
    sha256 x86_64_linux:  "687e6ca6eca2b79df485e06ea9eac3f1a5b0a270e5d6c80ffbe4e67813e01f71"
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  # The build breaks when it tries to use system `tclsh`.
  depends_on "tcl-tk" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"

  on_macos do
    depends_on "libgpg-error"
    # Build again libiconv for now on,
    # but reconsider when macOS 14.2 is released
    depends_on "libiconv"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --sysconfdir=#{etc}
      --autocrypt
      --gss
      --disable-idn
      --idn2
      --lmdb
      --nls
      --notmuch
      --pcre2
      --sasl
      --sqlite
      --tokyocabinet
      --zlib
      --with-idn2=#{Formula["libidn2"].opt_prefix}
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ncurses=#{Formula["ncurses"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    args << "--with-iconv=#{Formula["libiconv"].opt_prefix}" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "set debug_level = 0", shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
  end
end
