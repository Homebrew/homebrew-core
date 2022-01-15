class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.5.tar.gz"
  sha256 "accb41b9bad3415017207c0992c791e4d887c505d5aa1b3be0c44456489e537d"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "9756102b1beb9415249da9c9f2acf51a81516e307ddc3702af0311f78dbc9fef"
    sha256 arm64_big_sur:  "c21775dc4cfa460cc639e140be476c3dc19691430fe6c9d2860dc54f0336c816"
    sha256 monterey:       "b59d31929cf258b83e92c76e357f67ca4dabdb38ebd5a896ca83364d058a8a86"
    sha256 big_sur:        "7f4da6cb377229ed6d6200af930520217bae1f96407e722badda9d36f646bf50"
    sha256 catalina:       "a91a83f40ecab3c8afdfbe63962e211d4fc05c22b41b59ca67d816fb0f595a94"
    sha256 x86_64_linux:   "03a80b20f53131a4f7706e4dcf84ee91ac22493930b99e10dbe6b77991866dc7"
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
