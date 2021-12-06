class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "b4839108ca8f9aef31d2f537485cbd878356bbcd4ad4f7a4dd19e72201d01cee"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "aec4a3abff403d5f738c721ae4f17066c855889de36e2d27589bd814ff2495ba"
    sha256 arm64_big_sur:  "630f194a6d12b321def6fe2637b00db853dd9449e427de90ac25399c15cd1fc4"
    sha256 monterey:       "47865472978bd2bbab407134d04a2656b8ef637dbd71531b72d25c7f2e6e1da0"
    sha256 big_sur:        "e5563070d3751c4ffb5b8723eff201c04b0f27c7aa04d8a4e97345a70356dd19"
    sha256 catalina:       "ec3bf3fbc15be7de373947e72321569bbb8554bcf0ec088b6a2964636044cc32"
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
