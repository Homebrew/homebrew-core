class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20260616.tar.gz"
  sha256 "2c34fdd2166d5765e6bfdc21d1248bc4e92ddc0a33537b9418c17cd90e2dda80"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "163c2785303fc2a896fef0bb83596edd6fdf8768a12bdbf706cdd46de6cec220"
    sha256 arm64_sequoia: "43bf302ac98c978dfe6e52c269ff09067049c80641e8299267811fe5c82e9398"
    sha256 arm64_sonoma:  "b2fdc688fc1c2fe562fc92a0787adae69d5a979059a0476adb80a5e7c8ef2634"
    sha256 sonoma:        "281846228aa1eaa569b944c0b707d01951a4acd13447e196bf903ad98c911376"
    sha256 arm64_linux:   "5e69c159556cd7684c82f5cbe4e204318dba65abb911751af02f46e38aa05c21"
    sha256 x86_64_linux:  "e3e21c0fdadc345d64fa70f0067eaa2c1ee5b0920aaf686e6045a98c339d1954"
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
      --with-idn2=#{formula_opt_prefix("libidn2")}
      --with-lua=#{formula_opt_prefix("lua")}
      --with-ncurses=#{formula_opt_prefix("ncurses")}
      --with-ssl=#{formula_opt_prefix("openssl@3")}
      --with-sqlite=#{formula_opt_prefix("sqlite")}
    ]

    args << "--with-iconv=#{formula_opt_prefix("libiconv")}" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "set debug_level = 0", shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
  end
end
