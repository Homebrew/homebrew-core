class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/refs/tags/20240323.tar.gz"
  sha256 "b6f397cf90fc18c925a7bcabcb75393c7cd2751ccd50efe93a4f401932513c45"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "8b5a97acd8efd445c812f9362abe71a42628b01368353f095e0bf7603c3c820c"
    sha256 arm64_ventura:  "acdd4e7a51f442fb52a8588842309adb43a9cdc6470d22167bff20cc5d759bfe"
    sha256 arm64_monterey: "c0726ac45ba19f9fba4417e2a6d5d4e06b36f8118d3a30c20ddc97ec20e9bf39"
    sha256 sonoma:         "38d031428b164d0ac808c367faa6ac80cb04aa79176cc7edc3217fd806d0c5a2"
    sha256 ventura:        "26da78e044ff5fa8ed5ea2217ae56389c604cf195f8a0e9144e52852371d331b"
    sha256 monterey:       "724fa2dd46ab58bb680beb285d8585c66b3c2b3525dc661a9771fa5fbe75f009"
    sha256 x86_64_linux:   "10563ce40c776a66871e655a5e42988a8306a2b893b385bcaf244b7870283cbc"
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
