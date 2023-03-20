class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.9.tar.gz"
  sha256 "e5cc02aea82814b843cdf34dedd716e6e1e9ca440cf0f899853ca95e241bd734"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_ventura:  "081a928b163ca1b17e5bf5031908c4403d1f49d58b37c41caafa8174bbcbe189"
    sha256 arm64_monterey: "9f759b7d50b4f77e78b0af8bd22bc43fbddc5a81bfc4444f17f023abdefee9a9"
    sha256 arm64_big_sur:  "2702f7a442a3f6815552c8f3932292722364abe65d5ea9a1fbfb22d4f1b9dbfd"
    sha256 ventura:        "084f401cfc56e193da5f7ab839c958012ce3ae70bbed31543151b7fb46045566"
    sha256 monterey:       "2a43e64c4a4caf23442f3370d589db60a594cfe34ad225a9d545fd29d5f03805"
    sha256 big_sur:        "ce0bd1d49e2b64e2a756e9f25a09358d8adb32ce5de87e54882419ae682c290c"
    sha256 x86_64_linux:   "536a4aff3145684b136b949af225c36af33b258e9b33ebec5e57570d8ffff8c4"
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
