class Nuvie < Formula
  desc "Ultima 6 engine"
  homepage "https://nuvie.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nuvie/Nuvie/0.5/nuvie-0.5.tgz"
  sha256 "ff026f6d569d006d9fe954f44fdf0c2276dbf129b0fc5c0d4ef8dce01f0fc257"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "93db83cb47b7c6f93b2d6adeb1d6fcf12f72920dd32185983a6d24fe0f63002e"
    sha256 cellar: :any,                 arm64_monterey: "987e483a02d53595c23a2174ba7603e2cbd03f0351ef8d1ba2cf210c73aa5540"
    sha256 cellar: :any,                 arm64_big_sur:  "ae3f93506890f1ab1f1ddcb1395eeb42988ec5afb7896bc08a6b9786f48f6b6f"
    sha256 cellar: :any,                 ventura:        "12738cb1cb602f6fe23b4180e137e25f55fc2db9b950e7c666d4d057fb08b6c6"
    sha256 cellar: :any,                 monterey:       "d88f929686eb725ccb1702103cf814e40047ce6bfaa0cee764a601c2d84724ad"
    sha256 cellar: :any,                 big_sur:        "8c0568e88b4192a2d6ff1511d560214efb1e1c914116c78ce1350fa9b872c09d"
    sha256 cellar: :any,                 catalina:       "252ecb752212720f38209762e1ae067cc25e77e9c5c4939ce01040c4e86fae5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f177e380622df80bbc34340afde5d533df0d29f6a9a671fe416f57d1222643a"
  end

  head do
    url "https://github.com/nuvie/nuvie.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "sdl12-compat"

  def install
    # Work around GCC 11 failure due to default C++17 standard.
    # We use C++03 standard as C++11 standard needs upstream fix.
    # Ref: https://github.com/nuvie/nuvie/commit/69fb52d35d5eaffcf3bca56929ab58a99defec3d
    ENV.append "CXXFLAGS", "-std=c++03" if OS.linux?

    inreplace "./nuvie.cpp" do |s|
      s.gsub! 'datadir", "./data"',
              "datadir\", \"#{lib}/data\""
      s.gsub! 'home + "/Library',
              '"/Library'
      s.gsub! 'config_path.append("/Library/Preferences/Nuvie Preferences");',
              "config_path = \"#{var}/nuvie/nuvie.cfg\";"
      s.gsub! "/Library/Application Support/Nuvie Support/",
              "#{var}/nuvie/game/"
      s.gsub! "/Library/Application Support/Nuvie/",
              "#{var}/nuvie/"
    end
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-sdltest"
    system "make"
    bin.install "nuvie"
    pkgshare.install "data"
  end

  def post_install
    (var/"nuvie/game").mkpath
  end

  def caveats
    <<~EOS
      Copy your Ultima 6 game files into the following directory:
        #{var}/nuvie/game/ultima6/
      Save games will be stored in the following directory:
        #{var}/nuvie/savegames/
      Config file will be located at:
        #{var}/nuvie/nuvie.cfg
    EOS
  end

  test do
    pid = fork do
      exec bin/"nuvie"
    end
    sleep 3

    assert_predicate bin/"nuvie", :exist?
    assert_predicate bin/"nuvie", :executable?
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
