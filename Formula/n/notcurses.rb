class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.17.tar.gz"
  sha256 "b0fbe824984fe25b5a16770dbd00b85d44db5d09cc35bd881b95335d0db53128"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "b0b8b649a5a676859495f2061505cde8e7795e6d0be2a43133afd97f7843081d"
    sha256 arm64_sequoia: "50bdced07494b0596889464b5e3fb272f585e54423b3759118de702684780afe"
    sha256 arm64_sonoma:  "bbdca156fea3181ae9cab1de61a22e92ccdd91b9b7996fd05e1dcc61917726a8"
    sha256 sonoma:        "140d9bfa2fd4c8654c96be30d3c4c513a7f24d2681d40868ce306ea13b689be2"
    sha256 arm64_linux:   "fde4c010fb9bfa94f995ccb10f672d621cc0a704dd740bd7d643db6c0a86b82a"
    sha256 x86_64_linux:  "57dea2e9fe2812b6028b6de3e2c7a4368248c3d3737538041c5047e30ace23ad"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output(bin/"notcurses-info", 1)
  end
end
