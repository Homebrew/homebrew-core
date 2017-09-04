class NestopiaUe < Formula
  desc "Nestopia UE (Undead Edition): NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://downloads.sourceforge.net/project/nestopiaue/1.48/nestopia-1.48.tgz"
  sha256 "e8a0f93569bc764427ec90cdee658ddef209601b4f4d3cfb4360563609b4a122"
  head "https://github.com/rdanbrook/nestopia.git"

  bottle do
    sha256 "9f66bf2e5c42ba743d4967d5b3cb9f4993a265a619dfd71de74478273a0b1f38" => :sierra
    sha256 "1e319cdecfa2dbe1779b124cd4d758921d64128b0ccb06f1aab8a1d23a428fe9" => :el_capitan
    sha256 "f3dda418bd311d3c4fd4856fb8464dedac1fa1051864497b365bc42cb683d59d" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libao"
  depends_on "libarchive"
  depends_on "libepoxy"

  def install
    cp "README.md", "README.unix"
    system "cmake", ".", "-DCMAKE_INSTALL_DATAROOTDIR=#{pkgshare}", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match /Nestopia UE #{version}$/, shell_output("#{bin}/nestopia --version")
  end
end
