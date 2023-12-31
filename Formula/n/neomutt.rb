class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20231221.tar.gz"
  sha256 "b2add3823db78d8c0a86507ef3b244a3487d7e7a70c0d9e4e4b136acda9004d2"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "8798b192b6d9e129ac757986c7103815e5d85354d7a17192ea7d59d84066db3e"
    sha256 arm64_ventura:  "3838d9f9e5966e4a5b1080042aaf3c49dfd285619579e99070de185c6b8033a2"
    sha256 arm64_monterey: "1a607e7f381d8b34a3386263f4e3f0866c24287ee244d0942dfbbefffe3d32b7"
    sha256 sonoma:         "aa52a698874d66db931c85dc684506dc3686feb1dcfe99a50d51930c579d7000"
    sha256 ventura:        "7fdd74f6da2c3fe67659635fefc68ee46913b6272665df3627047cf9b0b532cb"
    sha256 monterey:       "c3695d5b5b715bd8aae50f0a0c23e633a0e3fbeb85567bece938a7fe2cb2aad0"
    sha256 x86_64_linux:   "d53715cbf5927b328ece1e7ab9c52012489a613b443f987b871017fe643c60f8"
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
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
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
