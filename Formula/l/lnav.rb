class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.12.3/lnav-0.12.3.tar.gz"
  sha256 "db5eee92aa00ce0b0614186c918a11db2fe6c06104fb615ad82cbea295ea6dac"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8cfe7f2d7e7b5e91d73a0403114e39b7002d6a30118b473829e173d02e002cea"
    sha256 cellar: :any,                 arm64_sonoma:  "818f11e9ea89c2846e52dd55bde68e120134559724606ce6d9dfca6e75758a7a"
    sha256 cellar: :any,                 arm64_ventura: "006e087ddba4a2d4d952b07519b6b133d7789e26128538228a5497fd400da9eb"
    sha256 cellar: :any,                 sonoma:        "b1c1c47cf54a10a5fb050785ba8bc8e2ac6d104b9bace376c6075b9990659f7d"
    sha256 cellar: :any,                 ventura:       "4c8db944f681b29e2510cce15fa5f0efa23d2b80ba26d11597b5330c70025877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2911a883a7cd44aab2c9237748d379c74399e9ae180e8108e2134ef43a1dcacf"
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
  depends_on "rust"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          "--with-ncurses=#{Formula["ncurses"].opt_prefix}",
                          "--with-rust=#{Formula["rust"].opt_prefix}"
    system "make", "install", "V=1"
  end

  test do
    system bin/"lnav", "-V"
  end
end
