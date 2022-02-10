class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.6.tar.gz"
  sha256 "2113bed52248b048874bceb99f10985ae46019de818fce5cda2a8756b013448b"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "437915c07163c65bdd214d00e71054207d119d8ee741e88e5824d866b3f06d4f"
    sha256 arm64_big_sur:  "bd1cd839e4eb79ff4a6f5409eb50e0e72947564020834d66eb393072f3224874"
    sha256 monterey:       "f43424d07adfc30bbbbe157815b844ddd5d30e85bf625beab4ba7868c95bcf6c"
    sha256 big_sur:        "ec59b99c00df9ab4a7a453c2c19e19aa2b9f72b4a234a463383140578dca674b"
    sha256 catalina:       "1b00378c072dee3aad052e0cee3c1782590827808863aa637d6c908a83dc314a"
    sha256 x86_64_linux:   "30c843a9d29057d547500acfa5053cbfaad2793b82fe1be0051faf3ec31396e9"
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
