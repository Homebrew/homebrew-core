class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.9.3.tar.gz"
  sha256 "49f0ee49e3c4a95f5f75f6806b0406746fcbf2f9ad971cae23e2ea95d3ec7837"
  license "MIT"
  head "https://github.com/allinurl/goaccess.git", branch: "master"

  livecheck do
    url "https://goaccess.io/download"
    regex(/href=.*?goaccess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "5891b85cee0e98725ca30c235a738068a5162b47f85c868c503456fae8a5d8a5"
    sha256 arm64_sonoma:   "87aa707dacbd55256870c04738ba57e253767e167c16bcd391f9fca89164931b"
    sha256 arm64_ventura:  "fab59a784e6221780e73de49fb5b7b20b8be593a0fab28d07f031b5b1433a8e0"
    sha256 arm64_monterey: "7cc09da579a2685826fec756cce8bf87fb868120ff09f680203fa172ad1d3af3"
    sha256 sonoma:         "1b64c1206f019b712ed90724342e12ed9962e48e33d4f6ef0cb3dbebc184454f"
    sha256 ventura:        "d0dde1b682b280570fcfe938d46c0ab44f8d79c30fbb0b167c203ecc0e93446a"
    sha256 monterey:       "40999cea57bc1fca15720fc2d11304db6801b2ac1a89d9da74910fd049944d28"
    sha256 x86_64_linux:   "a3ee515f40ffb70cf7db643c7150156a19558ec33a1426a792bad4b4434aa42a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "libmaxminddb"
  depends_on "tokyo-cabinet"

  uses_from_macos "ncurses"

  def install
    ENV.append_path "PATH", Formula["gettext"].bin
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-tcb=btree
      --enable-geoip=mmdb
      --with-libintl-prefix=#{Formula["gettext"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"access.log").write(
      '127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" ' \
      '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) ' \
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"',
    )

    output = shell_output(
      "#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y " \
      "--log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' " \
      "-f access.log -o json 2>/dev/null",
    )

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"].first["data"]
  end
end
