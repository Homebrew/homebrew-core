class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.9_src.tar.gz"
  sha256 "6819cbf3a883a5b613c3b7f29255aa935afdb0c2dcb14c04e644d5b24be117c1"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "be9e239d5a8a0d7c2c370ebeb1da5bec46b5777a80256785b1814cb0ab017e1a"
    sha256 cellar: :any, arm64_ventura:  "229b5feed72d036488d80ef4ef2fe96bd7e2d1fd271dfaa9aa40655c340f53c1"
    sha256 cellar: :any, arm64_monterey: "37781db44c8a949860010f57d39a163ee98a4b535e9100fa5b63e62b0cba102e"
    sha256 cellar: :any, sonoma:         "d9a2cd62e9a98a455e796752f672d74c0e1bbf18cb71e91dd2baeab7760f09f7"
    sha256 cellar: :any, ventura:        "1a96503bb5fda1a4fa01a85ae993a1fd10eec10e11c301f6f46c085900a555c9"
    sha256 cellar: :any, monterey:       "cfc9f0f934b4d195a6aa2982467caf63e57e3027a753f3af52a0856bd8325446"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "sdl2"

  on_macos do
    depends_on "gettext"
  end

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
    sleep 45
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
