class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20260504.tar.gz"
  sha256 "93fd8344c12cd857f084f8d7cc1187479f79036ab9725cfdbc81c0cc845f1615"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "96708333b3b29a6db760402341f3a33b99d34428d9014935881feaf7fdcd6341"
    sha256 arm64_sequoia: "cf9849d83a01755f544d07398cfa4b15201ef6832c457cee3a209f981a4e11dc"
    sha256 arm64_sonoma:  "315c20a60f4630b4898a778dc0b0bcf1ff42e9644505783bed674e0de954964f"
    sha256 sonoma:        "f94cb00a9b7d3858246bda6275951d26c34bac2d3230c26531d8483e565e897f"
    sha256 arm64_linux:   "4e9847028070cc0c0168fbe7ba976cf1e0c7370b3aad67c67e19a4bd7f64f287"
    sha256 x86_64_linux:  "f646b84ddb7b3378e585ff6841374ad23fa78fe22213f8a7eec28bee72a251a8"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  # The build breaks when it tries to use system `tclsh`.
  depends_on "tcl-tk" => :build
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"

  on_macos do
    depends_on "gettext"
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
