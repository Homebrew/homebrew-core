class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20260105.tar.gz"
  sha256 "a78e55a0df62b7f98566676d0ab9041aad89b2384bb5c6f3a96302a5cf49968d"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "fe95b1debd202453fdca5017ff4cd9305f3fb5703f719f83606b5146088dca5b"
    sha256 arm64_sequoia: "5534c6ec2c7394e76020fdfbe22576fbabd5ed1f2e2963786c3742b778530c16"
    sha256 arm64_sonoma:  "1983d5d12514db0559f68b71b473b7c91f390e4a97c199f9cd21c97e82e6d41b"
    sha256 sonoma:        "0fc4334fb2b32898ffd9f77d2616b322d747f719a934804050273de3d9953838"
    sha256 arm64_linux:   "ce956ce94db77838e334a175968b5298cee9512bcb7905d8570ff46cda033dc6"
    sha256 x86_64_linux:  "3a2b4dfed12a64e42e2cfb250feed693c2afb7fd96688fff6aebf19b723d49c6"
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
