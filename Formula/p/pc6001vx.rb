class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.6_src.tar.gz"
  sha256 "47cc6328cb2febc1042c0fa03dcc5043e7756560cc0528bdc7b8a03a0ff4cf1e"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b1baea3be049d1b630c4552c40295f56e112d5f5a5fcd79c582d10bbd79f1981"
    sha256 cellar: :any, arm64_ventura:  "fc296773e9ac1220d7c3d570404e8182918a6f5a6d00ba6e5cabebd270e90087"
    sha256 cellar: :any, arm64_monterey: "0a2ee943446f7bcb508eecfa8fb70e60d7e9b484a245a5353ae76f7f2a06c115"
    sha256 cellar: :any, sonoma:         "4fde6d51d7ed38eccdc780777009fec6aadad8950ce2733081f1039f4468ae0e"
    sha256 cellar: :any, ventura:        "b756277c12d40f433f77a5478c781e012f27a46acf1f506225badf8aebd1da8d"
    sha256 cellar: :any, monterey:       "fdab432f8dc538adb2f54ce293c585e80f135e944a21d7fda2e507041e934b94"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"
  depends_on "qt"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                                 "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                                 "CONFIG+=no_include_pwd",
                                 ".."
      system "make"

      prefix.install "PC6001VX.app"
      bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
    end
  end

  test do
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"
    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = fork do
      exec bin/"PC6001VX"
    end
    sleep 30
    assert_predicate user_config_dir/"rom",
                     :exist?, "User config directory should exist"
  ensure
    # the first SIGTERM signal closes a window which spawns another immediately
    # after 5 seconds, send a second SIGTERM signal to ensure the process is fully stopped
    Process.kill("TERM", pid)
    sleep 5
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
