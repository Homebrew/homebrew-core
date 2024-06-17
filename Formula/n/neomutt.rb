class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20240425.tar.gz"
  sha256 "a5aed0a0f506260997821c23cb148bc5ca4938fd613e0e8b89556f397ffc17f7"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "bc7fdea677bc8393abc760dcc3ee3be1628c41e17a227dd686e0433c7273bfed"
    sha256 arm64_ventura:  "ac38b9aeecd87df8ab6e5a4fe24785c2b8801a2d10bcda667b85a63d5aad42cd"
    sha256 arm64_monterey: "9327bfac4994e34c6199182aa61ba081bbbf871bc429acf7210f73e15edebd07"
    sha256 sonoma:         "c9c3b1aa6564f0a440b2f419fd38a2f5d14a1fef5110024a546f9da0ee9f9ec6"
    sha256 ventura:        "e79de801c9ce1aec01b0e9077a5be4fa96287fc86dc32bdd9b5193cdbf60c862"
    sha256 monterey:       "465a0f3a2ffb435334fc71f15115b092a568cbf25995083a20ab0957f2831fd1"
    sha256 x86_64_linux:   "e7647714a64ec9e65bcc014557938039aea02bcb435b24344bf30577840412b6"
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
