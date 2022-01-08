class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.4.tar.gz"
  sha256 "467f826ab98e80a35a0ed10ff8f402fa6eba7e9d8cc297980856d73f659f4c19"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "b1060b15a7d88ac4fb50f5662338fd6a2ebac623baeb8e179b3bf637ec670441"
    sha256 arm64_big_sur:  "a4ccec36faede960bb7eb31acf056e1860d3ee4545512d35e29ae06dceac9ced"
    sha256 monterey:       "0c71881087a0e7738e03d46359f409071ef7c7f29ba13d3090a4c6e9461b345b"
    sha256 big_sur:        "e4ef60455f7275e82055b8bbc3181f88dce2ae5fcd5b4d6f9f87d97cba94e3dd"
    sha256 catalina:       "d393ad8b7836de08ae1afb87c61350ed80ebcd236163cd6171bf02b989772080"
    sha256 x86_64_linux:   "924ff15a1e67e4bc5eb9428968d210e38da2725891176ed0ff79fc8493b166f5"
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
