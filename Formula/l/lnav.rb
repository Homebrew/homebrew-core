class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.13.1/lnav-0.13.1.tar.gz"
  sha256 "b6443702d56c35b3b8598f9b1bbd1cbf4548e5c213caf01680af7207bb25610b"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f683d861edfd0d472409c9e54dc97e877169e56baf7f8fba6824545e9ed4918"
    sha256 cellar: :any,                 arm64_sequoia: "67680a240a10e7caf6e865cabd617cbbc77c97f5e4b8f257ed5519d2180e6e25"
    sha256 cellar: :any,                 arm64_sonoma:  "aceeaf1385343eb892e38e3d666f2d09eee08e2fd9861029cbd0b5541ff2b252"
    sha256 cellar: :any,                 arm64_ventura: "ce354f9f3295c7f420404b7bf03a3fe08fd4cab96f11b0d2584b8c3bc52b6274"
    sha256 cellar: :any,                 sonoma:        "fb303c355d05bce93e717b7ae7e5e528d487d0d1b2d33206fd3205dc820c1ab9"
    sha256 cellar: :any,                 ventura:       "7b3082e00ea9c2de8a67144eb584f747003787eb0939ce725e057a7ec1653339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e9aafedef046e6f7cc01bc142280f37f0aa7569bb5b24e5454739592fedb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee12bf35f2a62221aaef14d354b626a3bf20cc715876da1b2027cbcb6c8ade47"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "re2c" => :build
  end

  # TODO: Make autoconf and automake build deps on head only upon next release
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "rust" => :build
  depends_on "libarchive"
  depends_on "libunistring"
  depends_on "ncurses"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # Fix to error: windows.h: No such file or directory, should be removed in next release
  # Issue ref: https://github.com/tstack/lnav/issues/1538
  patch do
    url "https://github.com/tstack/lnav/commit/5df522e53fea7f07f113c2d83093cd789f8496ef.patch?full_index=1"
    sha256 "cf2c00335fb56dbb0bfeee958ad4c14687aeb7e8c9ef097f4f5fad9c75f0c4d7"
  end

  def install
    # TODO: Run autogen.sh on head only upon next release
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          "--with-ncurses=#{Formula["ncurses"].opt_prefix}",
                          *std_configure_args
    system "make", "install", "V=1"
  end

  test do
    system bin/"lnav", "-V"

    assert_match "col1", pipe_output("#{bin}/lnav -n -c ';from [{ col1=1 }] | take 1'", "foo")
  end
end
