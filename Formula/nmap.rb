class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.92.tar.bz2"
  sha256 "a5479f2f8a6b0b2516767d2f7189c386c1dc858d997167d7ec5cfc798c7571a1"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/dist/"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "c4825eebb0c857ba379710908a624e3564662bd808fad068a072ae7a90b33ac7"
    sha256 big_sur:       "cb8315d8d7913081b82c5fd23af831e4d35b2d87581bfa395d6e4ff30b8d45fd"
    sha256 catalina:      "5592fb8c2fe633a6339ee61901122c075a4b44c002e2887bddfb2c4b3aa2885f"
    sha256 mojave:        "ba808d31033d996488fdf56664de1cf424fc942db794ab7030d40a1caad93aa8"
    sha256 high_sierra:   "b9a5b9d54fb0af76b1ce343e94f142b3421309fbeb81078d73e41bc2a9d862ea"
    sha256 x86_64_linux:  "1b532fb1c4570e3f849c5b9888046c116af14a0421c824f082a87f2462ce59cc"
  end

  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  conflicts_with "ndiff", because: "both install `ndiff` binaries"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    rm_f Dir[bin/"uninstall_*"] # Users should use brew uninstall.
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
