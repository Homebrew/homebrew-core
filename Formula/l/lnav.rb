class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.12.2/lnav-0.12.2.tar.gz"
  sha256 "25356f8bb4febc6935d6e675d1803969f6eb44d9997eb8cd7dc9cbab56c65972"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5b496dcf9673b71030d90616ecaf58257bcfc387c14bd6cbdd13ba0557f336f1"
    sha256 cellar: :any,                 arm64_sonoma:   "80b8918f94160300cff29745767717b71af097c7d296948d90c44e69e45ba156"
    sha256 cellar: :any,                 arm64_ventura:  "d1b3ffd05f8a7b4f3b49d0d14839eb13ba67fa52c5e7b85a5dd99ad554610627"
    sha256 cellar: :any,                 arm64_monterey: "d0b50c12666431385fafaeebf06f20fa58bda84653abf2cb178a62bc0c86a40a"
    sha256 cellar: :any,                 sonoma:         "7eedd1448358cb92f27634ab5d28710f45ec81c52505e90cb647e535c1666e56"
    sha256 cellar: :any,                 ventura:        "10c576bef574f0c5677feb155b2cc01f28295fa7fadbe46d8b3a5c28bad83586"
    sha256 cellar: :any,                 monterey:       "9501d57fead1c7f49bce092ce360dd177c60f454a2e5254f21d061fab221181d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab0fd59e71d64c25540c4ab06b5d138b0e61a272be5b7474974ddc19ba6fbd9"
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

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

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
    system bin/"lnav", "-V"
  end
end
