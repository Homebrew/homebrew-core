class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20211022.tar.gz"
  sha256 "49aa5029665c6819e708276b9efa1ca71ec5afe870eb9f08e656107d234941e6"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "0a4c96ca443aaffb8b381cdb7597c78bad720e6d81ed5a3370603598b70c49da"
    sha256 big_sur:       "175d7359edf485abc51f63df44f1068ef7a727cea236189657ef6657b4869e07"
    sha256 catalina:      "80dee50fb2b138b82843a6a10fe3ded8803328cb85f1a3fc0432e927feb68059"
    sha256 mojave:        "c11cd76bd9a068ffdbd18a07b151d378b3567b2b986626d21c693ec53acd7a3c"
    sha256 x86_64_linux:  "cf4b81f0455730ee70c306e83f8209b1ba776624e3cf9dae227586d7394c0c58"
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
