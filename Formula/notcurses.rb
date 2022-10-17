class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.9.tar.gz"
  sha256 "e5cc02aea82814b843cdf34dedd716e6e1e9ca440cf0f899853ca95e241bd734"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_ventura:  "34d3a21fa36154110b37ad9cfac9c40044342ea33484288120d66e22ddd943a5"
    sha256 arm64_monterey: "775909949455ef932fe960a656989e7f0f893d1699f0a0be035321b5ad095cd8"
    sha256 arm64_big_sur:  "0ca63187446cc5f3681a3aa31616af97a5d078f566f018d7e5f953dd88a1ca19"
    sha256 ventura:        "70114af88cf86f16dcd602148b64f466516707a373d8400dcd4bc1661e422531"
    sha256 monterey:       "226bde7aa45f40b7f98def8000db38f3405096097b76a1ee688f2c9118d9cb91"
    sha256 big_sur:        "3f644430465f58e22d241a578ba9109089b94967d28d16188d6cbdc6991d7a3a"
    sha256 x86_64_linux:   "9fed2c0b158ef238c90648464e4a1d191bd8da23c4411b147ae2c9cdd2865e04"
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
