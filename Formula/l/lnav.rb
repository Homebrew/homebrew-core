class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  homepage "https://lnav.org/"
  url "https://github.com/tstack/lnav/releases/download/v0.13.2/lnav-0.13.2.tar.gz"
  sha256 "2b40158e36aafce780075e05419924faf8dd99d1c0d4ae25a15b00bc944f4d60"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "87192e0c02be36248bea532176d3c8e2103aeaa62c8f2cbe2fc9a567c8cf5547"
    sha256 cellar: :any,                 arm64_sequoia: "ceb331a54097ec199b506bfd03646907396f1431abe1d69c88f0b8737fb81277"
    sha256 cellar: :any,                 arm64_sonoma:  "dd19a8d070edd6c6f8eb89328e72ad8d4329e6f0fa074aa3ac65a98a3b0aaa6e"
    sha256 cellar: :any,                 sonoma:        "6830377816ea9dd669946e6ecf1314c88c33cb140f0acac0a58baea584a18619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "636ded0548e73e1793d84ab28701d4af38d0380a166fd6d674c76e94d6a6220b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dcb30b22cd92d66e5dea0190a0e5c3599f645b5832fe203539be80c26e4d767"
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
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--with-sqlite3=#{Formula["sqlite"].opt_prefix}",
                          "--with-libarchive=#{Formula["libarchive"].opt_prefix}",
                          *std_configure_args
    system "make", "install", "V=1"
  end

  test do
    system bin/"lnav", "-V"

    assert_match "col1", pipe_output("#{bin}/lnav -n -c ';from [{ col1=1 }] | take 1'", "foo")
  end
end
