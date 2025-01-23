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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a55494086aab577c233e4e023f4f4bd68a7fff6856633505248013ebfe9da4e3"
    sha256 cellar: :any,                 arm64_sonoma:  "07838a7c8f38c0332fcae0cf508af7f666eebcf3dff10afc1f8237e6f1fecc8e"
    sha256 cellar: :any,                 arm64_ventura: "1e597e57c011e89db872e1f18d96031be7445f98d7b542315c56677e1d22af45"
    sha256 cellar: :any,                 sonoma:        "5a207bb01325cd16ce465ec12bcd7c28f8aeb2edb0bbaba396abfc6ac370478d"
    sha256 cellar: :any,                 ventura:       "b40be20b4ec73caedc56d35da7652956b4d5fd91e9940f7bd26cc4c761528e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec59ca74bd90e1d2fac500906db30720e1dd2c7debba7395ad281dd769bec6cd"
  end

  head do
    url "https://github.com/tstack/lnav.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "rust" => :build
  depends_on "libarchive"
  depends_on "ncurses"
  depends_on "pcre2"
  depends_on "readline"
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

    assert_match "col1", pipe_output("#{bin}/lnav -n -c ';from [{ col1=1 }] | take 1'", "foo")
  end
end
