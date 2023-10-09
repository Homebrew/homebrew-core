class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.11.2/lnav-0.11.2.tar.gz"
  sha256 "3aae3b0cc3dbcf877ecaf7d92bb73867f1aa8c5ad46bd30163dcd6d787c57864"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c419e2a3947d0fabf11da0462d0df3268a862b3bca3f07f696ab914682614d81"
    sha256 cellar: :any,                 arm64_ventura:  "ace44e4760c5a5404747089b1bb9de3a911cc168b21785024001e6ff9daf8574"
    sha256 cellar: :any,                 arm64_monterey: "3eb2a1855390e0c40ef64f05db171ab50c3cc360e21ff3e4ad9885a9e4acacf7"
    sha256 cellar: :any,                 sonoma:         "ec3e6557fd9e161a21a2b8e6025a03a54bc576f1cdc402ffbb65d07d8715f457"
    sha256 cellar: :any,                 ventura:        "c3884cc6a95eb18bedf085ff8619c5e21408e807b63141911deb7aab838fca60"
    sha256 cellar: :any,                 monterey:       "da344c3d7106f68e27949713ab77b48bf195b720db10ec5e6099b38992fe0b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669b8996545079b6a7d50b19d39a71e7663e5a8384856c4fa266a868e9c311c9"
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
