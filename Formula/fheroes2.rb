class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.13.tar.gz"
  sha256 "f46479783511d2c244778e558a624db164102cedb6116419fed97ec862f9505d"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "5f081b0eacf3a40e7f2163d0c30831bf70f7241e2d05c1fd5414f8428a2a71ea"
    sha256 arm64_big_sur:  "0a7837be803ee0b1d08035163c11154eb2d3c3b85bd41cdba6ea88178baaa39e"
    sha256 monterey:       "a26aecca6e7680c9b8f3591c2e6fb2cb80abf25f06c691872e6bd3e675ebb258"
    sha256 big_sur:        "bb4661e9bbe1cf8ce6e55eb6287a9d58b50046d01990cd737ce68fc6a9e4749b"
    sha256 catalina:       "fc867885247e279c375f4f66237a02eff832e49d03ae980f93c0d8137f06391b"
    sha256 x86_64_linux:   "d38d2fbe73ea17ab6992835e82780b5073668ef73beb62d865f463642e7047d2"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "make", "-C", "files/lang"

    (pkgshare/"files/lang").install Dir["files/lang/*.mo"]
    pkgshare.install "fheroes2.key"
    bin.install "script/demo/download_demo_version.sh" => "fheroes2-install-demo"
  end

  test do
    assert_match "help", shell_output("#{bin}/fheroes2 -h 2>&1")
  end
end
