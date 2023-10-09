class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20231006.tar.gz"
  sha256 "94b9d5d8f927f8ceb4661549f5a490dc057af2e7f11de41e68dbc227dbf8a015"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "7c781c2fcb941d4d5425244182add29e212c881104ca1e8622f9933c78b41a84"
    sha256 arm64_ventura:  "6a7e5472791837bf9a7bdcb406f8bb02c0e555a073d0dd113d92fb4dfa47961b"
    sha256 arm64_monterey: "4fac0e85a672721d2ab950c857d8e42a417f531deed69db3880e519bd880dcfd"
    sha256 sonoma:         "5f221a5193c3f9a58c0ca14c92dd0ae02035454e1e54ee06ce64e13a65db477c"
    sha256 ventura:        "2ff33a95a9c89b22c062a6161703af09bd3cbb1693e1f34e2942a1caa18de0ba"
    sha256 monterey:       "a90eac6a947398c0fb07e8f587e64a81caa8296a954042f007f28280a84d3c35"
    sha256 x86_64_linux:   "0d878a87aea48aab7b4a3e44fa5d4c5bfbfbe135b00a5322f00caa8230626c14"
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

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --prefix=#{prefix}
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
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ncurses=#{Formula["ncurses"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
