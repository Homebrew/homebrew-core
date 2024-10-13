class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.9_src.tar.gz"
  sha256 "6819cbf3a883a5b613c3b7f29255aa935afdb0c2dcb14c04e644d5b24be117c1"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "f637d73fb2b4cc282009ec31ff733b3c2a387743acd93dc8a07c589bf913be70"
    sha256 cellar: :any, arm64_ventura: "c382fb9d7d83f11567071fe8a8f9992efb7b05b945d6c0316ec65a142cee6f8f"
    sha256 cellar: :any, sonoma:        "b1f76365c1fd422dd0a7ea60d38c3c62a12e4a66bedb8dd5592c0905d20ddba4"
    sha256 cellar: :any, ventura:       "ebc9b5019ca6e11e1dded702b91d39630b8e1d6f04c30c3ec6f0312251953c98"
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
    sleep 30
    sleep 30 if Hardware::CPU.intel?
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
