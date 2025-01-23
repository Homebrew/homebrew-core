class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.10_src.tar.gz"
  sha256 "82dfae60462770b1497a6131d9420cc32fb23beb44733c98f8e97eaa8df39a26"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "89277f30e85f0c53b33f4af245efe70e12620d8135d5c6bf96b85847b8577eff"
    sha256 cellar: :any,                 arm64_ventura: "f5eba22f7175f65796d9a1f69b5c1d6af1e0b571a09b0a142f278ddcb07320f9"
    sha256 cellar: :any,                 sonoma:        "0f6e6d416491e74e23b8ea156b98e161879c81aed4dd48c70f16c1d474e5fae3"
    sha256 cellar: :any,                 ventura:       "9b5ef2f68413dd80f20a9605ce7954bd696711e706fa3b5f89c4e0bcda96ffff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e936c5feed6738d8cb60c4b6a94ce0652beba32c096eded43a7a994625dab1e"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "sdl2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
  end

  def install
    mkdir "build" do
      system "qmake", "PREFIX=#{prefix}",
                      "QMAKE_CXXFLAGS=#{ENV.cxxflags}",
                      "CONFIG+=no_include_pwd",
                      ".."
      system "make"

      if OS.mac?
        prefix.install "PC6001VX.app"
        bin.write_exec_script prefix/"PC6001VX.app/Contents/MacOS/PC6001VX"
      else
        bin.install "PC6001VX"
      end
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"

    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = spawn bin/"PC6001VX"
    sleep 30
    sleep 45 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists user_config_dir/"rom", "User config directory should exist"
  ensure
    # the first SIGTERM signal closes a window which spawns another immediately
    # after 5 seconds, send a second SIGTERM signal to ensure the process is fully stopped
    Process.kill("TERM", pid)
    sleep 5
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
