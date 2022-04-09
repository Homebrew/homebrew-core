class Fheroes2 < Formula
  desc "Free Heroes of Might and Magic II is a recreation of HoMM2 game engine"
  homepage "https://ihhub.github.io/fheroes2/"
  url "https://github.com/ihhub/fheroes2/archive/0.9.14.tar.gz"
  sha256 "5532fa8443b8d8f54fcfc56628f1020470ad215e12285d78c8450e49ea9944be"
  license "GPL-2.0-or-later"
  head "https://github.com/ihhub/fheroes2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "6161f02c0c98850e2342c646caff6bb651091d327c33dfd5cf2df82082a3aeee"
    sha256 arm64_big_sur:  "2f5c2ac443d15b8b332f250639d3670a56fc33af623a6c5536ab8890ea7e9daa"
    sha256 monterey:       "b6c075231c89f6e8120bff962570d9bf2f01e33561887859314f81668a37ddbc"
    sha256 big_sur:        "399e347791e1adcdef994993849f7e71900c53f84d537600e6b04204bdd77fbf"
    sha256 catalina:       "7dbe42591224b3f9408ddc7f86fc9a2b833f2faf96c041bf618a230b94505a9f"
    sha256 x86_64_linux:   "77d5ead6152422c395c9da3533dfcddd2482961ec6324b61717da15a85d3cf92"
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
