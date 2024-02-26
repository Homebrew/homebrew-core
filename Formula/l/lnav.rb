class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.12.0/lnav-0.12.0.tar.gz"
  sha256 "a6f51a5019df1870c6a5889e337cf2cfc1365b04d81a0602f7f071ec971f5997"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "982776a815ac91387eeae50a575cd63ee5c2308068f2d50269c144626ccc80d0"
    sha256 cellar: :any,                 arm64_ventura:  "fe10f585040a47915393bf124993dcdf339397dbf87addc38feb67dc391286ac"
    sha256 cellar: :any,                 arm64_monterey: "3787a1aa6c5ebfb66a45c994f562f005a8ceb0d7f9d43ad22c3d5fcbb477b9a1"
    sha256 cellar: :any,                 sonoma:         "d04530276c6cc85e571ba91957ae95e6476a920525dc2560f051fd87e4b5fe29"
    sha256 cellar: :any,                 ventura:        "b1f74dc7e2721f2155ca7dac19a34d41d45745349bdef9e8bb2e3dd491495dae"
    sha256 cellar: :any,                 monterey:       "ab73609e4f9fd622268da25c07b814b2b12dd51d89fc418db385cfd928336da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5da66924b9943bc033bb6b0e455a59e7b78641f748a5e7b0e55ef304e4e8b1b"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "libarchive"
  depends_on "ncurses"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "sqlite"
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          "--with-ncurses=#{Formula["ncurses"].opt_prefix}"
    system "make", "install", "V=1"
  end

  test do
    system "#{bin}/lnav", "-V"
  end
end
