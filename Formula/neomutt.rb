class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20210205.tar.gz"
  sha256 "77e177780fc2d8abb475d9cac4342c7e61d53c243f6ce2f9bc86d819fc962cdb"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/neomutt/neomutt.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "ae39b68a39ee90a2deae8e5364edaa5f9703b551120c9d0519598f7d170378e9"
    sha256 big_sur:       "11d594b30c8ae5d522ff37d24337b2bc709c2a426f543a74af92f6d85f67ab97"
    sha256 catalina:      "a2cd24cd5c9d7777e90b7981eb3d6ac1d9bc3c761af4ba523f652379ec3c9829"
    sha256 mojave:        "65b02f471888f1f2b6eed4fcf47c0aded53bb64d4dc54eacfcda76958e0aaecc"
    sha256 x86_64_linux:  "470fa81738946d34e56d1bd8c39c8a355797ab2210c86434e4259fc1475fb138"
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
