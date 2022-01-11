class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.4.tar.gz"
  sha256 "467f826ab98e80a35a0ed10ff8f402fa6eba7e9d8cc297980856d73f659f4c19"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "fbe5cda9ec9f391e93b2d09f428fab5680a33e5bb9d8482c1d2329fbaeba3eaa"
    sha256 arm64_big_sur:  "b63269cd0d70300626d812300e7e6c33cfe110067ff8e300c2d4f189c0e3a6fd"
    sha256 monterey:       "457d7fc4620bd063d36f876f7569bed2e31cf949e53aea067a4d6fa6f93b5e32"
    sha256 big_sur:        "f3ce9cce402f0f573afa712e628ce347afd9eae4fd4e34345a21aa844ddd23e5"
    sha256 catalina:       "f16ca2fbd8649a8bbf76cb86c4c215c871c6f3052ea13b1d62fb120f22128671"
    sha256 x86_64_linux:   "f7b5551398c9aac9b4671e73b7c55570d70013f60b0fdf7d5d54f35bd671a672"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output("#{bin}/notcurses-info", 1)
  end
end
