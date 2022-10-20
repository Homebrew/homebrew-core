class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20220429.tar.gz"
  sha256 "45496542897ba8de6bc7cce3f5951d9033ed1c49e5d6f1353adaeefe795d9043"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "e9e21e018e976287ca9ce25f41cdb1b18604a4a6429ddf0afc9fd2cec5806294"
    sha256 arm64_big_sur:  "ffcba35c188f273f26c1710cb9aa2ee719c4e77778a3383eeaa383f7246d5c8b"
    sha256 monterey:       "88624a8ff7948237403ddf40d98c4a9ea410b85fa3327c0f34f19771f978a9a9"
    sha256 big_sur:        "c0a68a0170522d6151e819d0813036a4d997da34657be41794abf6aec0512ef0"
    sha256 catalina:       "dad7c71b94e11592fbc657b54495bd243d9a5ba9a092e38a136a998cbc26a06f"
    sha256 x86_64_linux:   "6c45f9bdc7e9748cb02081fdf9f0bd9e77a319c9f691d20d205891f38a42fd98"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
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
