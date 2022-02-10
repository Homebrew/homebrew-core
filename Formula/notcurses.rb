class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.6.tar.gz"
  sha256 "2113bed52248b048874bceb99f10985ae46019de818fce5cda2a8756b013448b"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "4e1c3dbec90215e2b3ca094c4a2cd52a156e576ebd8a79285934744803803e5d"
    sha256 arm64_big_sur:  "14928e9e8aaf355caef80373ed58a98dc715a9352f7e2de1d6a2ba6486c4f9ec"
    sha256 monterey:       "8b7cd1386321e1cb20269806c8f55b18bdf3026ecd5b130cfcbc98f59d57b7af"
    sha256 big_sur:        "107c3288b9d75751692e98dfb23c2cd2fb2fcd2dee3ef222e62c5dda964d4416"
    sha256 catalina:       "d531396214cce79e52920fd511450341d5632b41e1549ed6478579f528494f3f"
    sha256 x86_64_linux:   "99edd46e134bc397f3cc3e03990d9645ebff6dacb0839eca0ee1627a91cb8df3"
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
