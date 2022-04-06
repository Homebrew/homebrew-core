class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.8.tar.gz"
  sha256 "56c33ffe2a2bc4d0b6e3ac14bdf620cf41e3293789135f76825057d0166974fd"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "58f7737491662b0ef1b40e6aa699f00bd586e002a64d908d7d417516b5115621"
    sha256 arm64_big_sur:  "987a325b91731940f435d91fa9de5a9e54bfdbdaeb162943da9c222adfaeb07d"
    sha256 monterey:       "b18a014fbd45c98a1b47e52b15a6315f946b8dc87afbdf7a91c56894cd82b31c"
    sha256 big_sur:        "377e88f33eec371ee01de99ec523f1f068afbbb8a7fd631185ed6c3693667c42"
    sha256 catalina:       "54940204bbf01d0f036c181fed7fece37cca832d0a35a70af8e6462229d7d237"
    sha256 x86_64_linux:   "4ab89b73e5937b739bcf71f9ed735754cad8331322558172ad4a6a4e902476ef"
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
