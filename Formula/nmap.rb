class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.93.tar.bz2"
  sha256 "55bcfe4793e25acc96ba4274d8c4228db550b8e8efd72004b38ec55a2dd16651"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "7debf45813bcc5d01562e2191219173e5faf37669790f208068b5a97935c7910"
    sha256 arm64_big_sur:  "9395c62aa5b48e2dc6ad2f1071080ae14ac38a7a75c2c031208a2c02b67f56d6"
    sha256 monterey:       "d42ac93fe1e777c3460377ec94992397c32a0ab61a7c98fb54637d3f0442a151"
    sha256 big_sur:        "4930a59d6546c229c90c7680560822fe2609a7f2d12425d40af4f4fb6e660de9"
    sha256 catalina:       "c2ab40d041d915b8ef99ab7049931af23d99a44c5a8970aa420bfe3156dee3e9"
    sha256 x86_64_linux:   "77946dc2f15a7c0dc98587016a1d1961a456ca61079361233455ba8db69a54d5"
  end

  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua@5.3"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "ndiff", because: "both install `ndiff` binaries"

  def install
    # Needed for compatibility with `openssl@1.1`.
    # https://www.openssl.org/docs/manmaster/man7/OPENSSL_API_COMPAT.html
    # TODO: Remove when resolved upstream, or switching to `openssl@3`.
    #   https://github.com/nmap/nmap/issues/2516
    ENV.append_to_cflags "-DOPENSSL_API_COMPAT=10101"

    (buildpath/"configure").read.lines.grep(/lua/) do |line|
      lua_minor_version = line[%r{lua/?5\.?(\d+)}, 1]
      next if lua_minor_version.blank?

      odie "Lua dependency needs updating!" if lua_minor_version.to_i > 3
    end

    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-liblua=#{Formula["lua@5.3"].opt_prefix}
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end
