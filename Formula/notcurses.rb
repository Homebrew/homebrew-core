class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.7.tar.gz"
  sha256 "db461c6ba07a8e3735a51a1d2e706d249ae30436519f543fa5931d414019c770"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "667a2b6c58d61e16fe30fc0630997c9a8e403b136be033e5ef7c6baa7f84e516"
    sha256 arm64_big_sur:  "2fd510e9a747a09ce2940773997bea63f54dfc9a920a3f4a8941879376fe4953"
    sha256 monterey:       "78db29e055104bc28c05e19b2d357274bc06632ccb2a0c120335f8ad5af73017"
    sha256 big_sur:        "312986fd4d0d314ec976c23cd263b0fd15addd4ec63c19c15b3b9210ad5a657d"
    sha256 catalina:       "00226e7f7f9bfc1271037ce81c0d421a15efddc61fd808693c9ab414e62f75e9"
    sha256 x86_64_linux:   "4787de8244333d276a3e4b0c1e53df0dcff9cf8bd285c7f48646bcb550b94656"
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
