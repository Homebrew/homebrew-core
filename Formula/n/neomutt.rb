class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20251211.tar.gz"
  sha256 "2dcb88c939514e15a55ac24f29dcb23f55754100e74df98558fd5c4b1347e542"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "2c9d7eba7ffee51a5c3e82700187bc2d642e7e20c6f98122ffb02417fd9dd366"
    sha256 arm64_sequoia: "bc89b3df79a86a0ad64ad364637947ec454bebfc6fef12e82713f680afdae0fc"
    sha256 arm64_sonoma:  "5e028735fda85b4d65c7426dad5f89d4df7e7525da43703cdf86803eeb41cef0"
    sha256 sonoma:        "fc1c6273c07d157ed507c861a7acb2bf9b6630ac0c60df0ffcebafb4a36eccc9"
    sha256 arm64_linux:   "e96a147e2b729a1724b09f547c9cafa3ea55188e4c4fc856934fba64b21b9bfd"
    sha256 x86_64_linux:  "08e6875dac97939c550e31a091443a9fef504ac40a7b69ade02cf8e0cbdd749f"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
    # Build again libiconv for now on,
    # but reconsider when macOS 14.2 is released
    depends_on "libiconv"
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
