class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.3.0_src.tar.gz"
  sha256 "a5536f7bd4931b2efcbdcd85707a9c6fa82a6b169773e6d13d74cea8107ee9cc"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0da9f1919b004524e9677255d6829e1e5fb9a472a04405db822cf38b0bb5ea37"
    sha256 cellar: :any,                 arm64_sequoia: "6bcf86f65d128104f01b83e6969a1d0f6938ec0f52a8aeb856667f3e15a171cf"
    sha256 cellar: :any,                 arm64_sonoma:  "efcd02e0c65882c3effcbf79b4c0825c78ac9b43873277fc87f5fa21ae67a746"
    sha256 cellar: :any,                 sonoma:        "6642ccbb7526d4b08a5cd3fbae82119eec81c19634232d7fbb63d70d61cab34d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8afac0eb25d8086990982f1aa2e0bf2ea916e267beb9fc8a84661a30885bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b90e9cc7da63eabbd08dec431bb01db9522c7529d7b02dca1bd7b44ea2c3ea4"
  end

  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "ffmpeg"
  depends_on "qtbase"
  depends_on "qtmultimedia"
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
