class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8/easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50c422741d1d7eaffc764e6d4338484e9ab884c92c68944aea8917aa90010d40"
    sha256 cellar: :any,                 arm64_ventura:  "b1f816ed8d4291b0f4400a19cf831fe098eaf58fc0d52d7cef88e565e321f61d"
    sha256 cellar: :any,                 arm64_monterey: "4c9cbce83ebf39769b0a51e7a27dd0aba437f0a3979e8784485aae60c215b88c"
    sha256 cellar: :any,                 arm64_big_sur:  "932a5158ea1f97f7067a896ac40592e466cc0a99d648c0724c21e6f2ffe743d0"
    sha256 cellar: :any,                 sonoma:         "fe505919bcd2fe0c1912ccb81394a99cd61b9f8850a2ba937b613e5dd02cea48"
    sha256 cellar: :any,                 ventura:        "4ff38fabee40fa3a6bfe498e7ec4db7d4f0b2a90c310ef1946f0de8c6dc12d86"
    sha256 cellar: :any,                 monterey:       "ac2bb22fcfd1dc9691d145ea40611ba63c57e110781d9219def898cda1789f05"
    sha256 cellar: :any,                 big_sur:        "b9b53f93b5623eea5ef7c2437fdd4325f9792d42abf2a6b7309c44c85dee74da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1563c44b8f1fefdc027943c24787ad5600c94400a8bd8c5d4c38b6560bb137c2"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
  end

  fails_with gcc: "5"

  # Add support for fmt 10
  patch do
    url "https://github.com/EasyRPG/Player/commit/a4672d2e30db4e4918c8f3580236faed3c9d04c1.patch?full_index=1"
    sha256 "026df27331e441116d2b678992d729f9aec3c30b52ffde98089527a5a25c79eb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "build/EasyRPG Player.app"
      bin.write_exec_script "#{prefix}/EasyRPG Player.app/Contents/MacOS/EasyRPG Player"
      mv "#{bin}/EasyRPG Player", "#{bin}/easyrpg-player"
    end
  end

  test do
    assert_match(/EasyRPG Player #{version}/, shell_output("#{bin}/easyrpg-player -v"))
  end
end
