class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "e006c8d0a19d148d1fa779803e19145a7d8c5f1bf1f8e9e5d2c14a5e0d860343"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "710707d843bb9c74ae2edf84efcf21e2244c107f4af1cf0fb9517605e70ade13"
    sha256 big_sur:       "f60929c920587a25ac8cc087069ec863a378b89ba34099cc647822be559adc63"
    sha256 catalina:      "5f766103ee4c355198ac517407caca5a0f10093e31fd991821b99530a8fb67cd"
    sha256 mojave:        "0b0c0ee0b11f5db42928d26e345a8aba45afc25e0227ce9fed3505e0108b262b"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on "ncurses"
  uses_from_macos "zlib"

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
