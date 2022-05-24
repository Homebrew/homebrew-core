class Enigma < Formula
  desc "Puzzle game inspired by Oxyd and Rock'n'Roll"
  homepage "https://www.nongnu.org/enigma/"
  url "https://github.com/Enigma-Game/Enigma/releases/download/1.30/Enigma-1.30-src.tar.gz"
  sha256 "ae64b91fbc2b10970071d0d78ed5b4ede9ee3868de2e6e9569546fc58437f8af"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "d03595cec1ddb59025fcecbf6888f4aa111ea3109248dad844afff91da8589cc"
    sha256 arm64_big_sur:  "5b867b942c96de07f01505e2208cf578f744425346ba180e96ba3d569c4cc15c"
    sha256 monterey:       "61e64a23581e2e4771fa7a28e7a1da9f70f6d35ffe7f7585a4a40758466e3753"
    sha256 big_sur:        "679839e6002ae198d8f62c1c1379982630fa2173f41b8cf63b7b48b91c606dac"
    sha256 catalina:       "78472e57abc53c73a637928f6d58b075f387c7e15e140858e4a3b0c59fa1e2ae"
    sha256 mojave:         "fab7be7e356416ceeb52dd5a078349ef0a40c7f0a2f703ef43c9c7aeeaa1e239"
    sha256 x86_64_linux:   "7d28c5a21e674b2cbc1627a807370916695ff7feba86230fd4fce2e6cc3cb939"
  end

  head do
    url "https://github.com/Enigma-Game/Enigma.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "texi2html" => :build
  end

  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "enet"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"
  depends_on "xerces-c"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--with-system-enet",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Enigma v#{version}", shell_output("#{bin}/enigma --version").chomp
  end
end
