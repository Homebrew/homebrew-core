class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.94.tar.bz2"
  sha256 "d71be189eec43d7e099bac8571509d316c4577ca79491832ac3e1217bc8f92cc"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "32837a1f36a15fc942c681f200617aea268718f160b17142eee6a56618130d8a"
    sha256 arm64_monterey: "8b8a608eca65894cea2eb5fcce4a03077d6d19f12e36756b495c348bab46c1dd"
    sha256 arm64_big_sur:  "7151c4c2e2bdc0a1cf92512a6c6ac0bd186fe354d34be8d9e46fd0f3345a76df"
    sha256 ventura:        "96921fe7b2582895c84814d4d2c6898ecbed9d955f2afc68aaa1b564d4c05c7d"
    sha256 monterey:       "49003440cc34f92ad987fc529d166599c0facbd0955387e40ff8adbdf8542c2e"
    sha256 big_sur:        "53beae7109ad5e702bcc0bd810642d039f2d414f263f7874554d9a27b45ce2ad"
    sha256 x86_64_linux:   "62193145e556d35212fff9dde188e99183df8c40acfee8a8d7955b47ba72347b"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-liblua=#{Formula["lua"].opt_prefix}
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    # Workaround for "./nse_main.h:25:26: error: unknown type name 'lua_State'"
    # TODO: Report this upstream.
    ENV.append_to_cflags "-DHAVE_LUA5_4_LUA_H"
    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end
