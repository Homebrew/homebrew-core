class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.3.0_src.tar.gz"
  sha256 "a5536f7bd4931b2efcbdcd85707a9c6fa82a6b169773e6d13d74cea8107ee9cc"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc583a60c9740a5d32eef957ab29607d195bb5b3df2bd48cb2bbf9ca5cb94c89"
    sha256 cellar: :any,                 arm64_sequoia: "bb18666eaecfe0cac52f38cfd62e96ca86a628e99da2d9c310013ba57fb593dd"
    sha256 cellar: :any,                 arm64_sonoma:  "648bd5ff43a2628c375ac8719174794ab82a4576df6c8e976f75a0647216e627"
    sha256 cellar: :any,                 sonoma:        "f2f06bb81db5a8c5f8282aec9ffda9c902613b22e19379a338d6f4c5480f6369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c07878d6f75097acff1e644c451829d8d46d9006362e5f781e17351a3bdd653d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d484870b507bf1ee5c321595fcee9fa79ab68542d1f80edd4d8ff0864ff8a03"
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
