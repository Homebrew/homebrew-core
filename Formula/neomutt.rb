class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20211029.tar.gz"
  sha256 "08245cfa7aec80b895771fd1adcbb7b86e9c0434dfa64574e3c8c4d692aaa078"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "4c237578e16c4e2206e9bf8fc60ec5748efa12a3709a0676b6b2438ade7da3f5"
    sha256 big_sur:       "42d34fcc9c1b3d97623ae96833415c2c79b87453cd3c19d00e39b919a6c6241b"
    sha256 catalina:      "fdd0baffcb5c94b761a9ed454f1d96a8f6719eab3842f4a3239019e1085cb9f7"
    sha256 x86_64_linux:  "edfcc9cb08d618770605f3a0b9d6c97304277078b049675adc1629c2b1b333cd"
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
