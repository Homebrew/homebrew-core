class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.14.1/lnav-0.14.1.tar.gz"
  sha256 "870c896a6973e1e973007be1d66bba3aef23b2aa68411fb5cc85bb7dd21a7fb0"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0230034ee926967b39d28585f40cd63418e5f2f32b5ce9936ab636978a1f69e9"
    sha256 cellar: :any, arm64_sequoia: "b9ec6ca5e69e3478371a592bf335a99244f1b039f8b718dc6a87667e93ed7f23"
    sha256 cellar: :any, arm64_sonoma:  "f2fc7f1024bfbceb636be8c054e9a8dfadeb3125e1c6922905b261438b8ab6ef"
    sha256 cellar: :any, arm64_linux:   "ce3466eb8d6c53a6470fcfb3b97b02656d58724dc0685522dbae572985df43d5"
    sha256 cellar: :any, x86_64_linux:  "6a59543eba52b708612526699af3dd3542b242cb1d8ad77f30e9adae40051fef"
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
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--with-sqlite3=#{formula_opt_prefix("sqlite")}",
                          "--with-libarchive=#{formula_opt_prefix("libarchive")}",
                          *std_configure_args
    system "make", "install", "V=1"
  end

  test do
    system bin/"lnav", "-V"

    assert_match "col1", pipe_output("#{bin}/lnav -n -c ';from [{ col1=1 }] | take 1'", "foo")
  end
end
