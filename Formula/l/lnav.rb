class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.12.4/lnav-0.12.4.tar.gz"
  sha256 "e1e70c9e5a2fce21da80eec9b9c3adb09fd05e03986285098a9f2567c1eb4792"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4c9cb81635f0fc220f9bca74d6ad1d3942744bc1f2251bb7e6475441a5a242e"
    sha256 cellar: :any,                 arm64_sonoma:  "c5d123bf1eaf7d5600fdea80e7bd01951e0bb6d18138c49345ccdf53f67c2c59"
    sha256 cellar: :any,                 arm64_ventura: "886782b7082477516598d6b9c7bec174f1edbcd3cd475a32a5cd16e2106a6414"
    sha256 cellar: :any,                 sonoma:        "d37b40a1558c099d62eb51a11a85d03662b2112019204ed584463dd6026d82ce"
    sha256 cellar: :any,                 ventura:       "7ba09f2325ae17889ec1f4e5798bb34d2db92b31d2d99874e52543b1240192c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dece4fd9feb77c9de00fa499d7d943f234fb3ac46c0adc4beabcd64458f6087e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f808305b7e2f68c68823cc5623f399ef17e9daceaf258aa3fc36a175495db30"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

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

  def install
    system "./autogen.sh" if build.head?
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
