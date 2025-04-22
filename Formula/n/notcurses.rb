class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.13.tar.gz"
  sha256 "cf6342e50c02b830869bd28d8c953d22316b942b671e833c0f36899502084b35"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "1545c6acf227d75acb8eac61fe1e9560a3af3dfe341d82b20696a65eeb555a05"
    sha256 arm64_sonoma:  "a63ab6d9910e361595832480785cc157e7b7f0ecd86051eb61b063f3fcb3c301"
    sha256 arm64_ventura: "4a04db71fd48279d7da206b54a1cd7eb4a0c7999effa37f68facb33addf4d725"
    sha256 sonoma:        "3b8e20008a62da4cc03b8d0905c88d9f0ab4e26bf21e76cd8207707e5aaef259"
    sha256 ventura:       "5a2f7147f2a7c98c61ab5085d1050df216e30fb17258141a197ef6b64fa21cd4"
    sha256 x86_64_linux:  "eb34f639ffe338807ae9d20ccebc4fad5948594daec483dfb97377038e15db83"
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
