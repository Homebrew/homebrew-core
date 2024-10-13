class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20241002.tar.gz"
  sha256 "8d5673d9cc4b239adcf4bc718d372c8c85d0b53248ecd628358625c877a53064"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "1f23f328fc319b165c5098e039c8828f292ebda873292a92a2fa1f6d9f480b24"
    sha256 arm64_sonoma:  "bad6b01c064964d44a25c07f41fe97daebd0eaba1a462b40883b189b153ac6e7"
    sha256 arm64_ventura: "c8089b9563eeb881c776052b55bfba069e89c181570447ed94916af4b1b7445f"
    sha256 sonoma:        "6a053929de9b0b88a6e9d9de5572fee3e95e3df8f8449f035a25e22d90d97eed"
    sha256 ventura:       "d4096559ddf7bc9cb6a6f500d5ec152678a23666a9657b6e94838aa4bf9ea3e1"
    sha256 x86_64_linux:  "70218512a0db0ac376d5ece31926033733c6c9f310acd4d07ecf236be0b614bd"
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
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
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
