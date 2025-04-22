class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.12_src.tar.gz"
  sha256 "344c8c4a8947d3dd8430ff4eb4a6e5679ac574bc268d0c4cefe3c341f1b79610"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "6c44a7961c6c4cb75d0436f10e5dbb163ccda2fa50663a29c06a3f90658328ad"
    sha256 cellar: :any,                 arm64_ventura: "2f51ff79b4b4942c922556e2a2ac618a6d2084ecce9d5cf6c4db1b8f7bbb4c6f"
    sha256 cellar: :any,                 sonoma:        "8fc6c40989a9c9fccd205a0ceca1a345508dfb5903188fca943ce655c9f0304e"
    sha256 cellar: :any,                 ventura:       "4d8400ad9c8288c9fe10f1dcefd75656e50424254523215bcb74794f5354740e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3915318816e5fbec75f5ca1610c47c28f00e7576f89c180cdfdac14a0722518a"
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
