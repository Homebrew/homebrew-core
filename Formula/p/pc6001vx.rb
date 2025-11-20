class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.14_src.tar.gz"
  sha256 "8b572e0dfb105ad003d7ebdbfe0d081af1189052f362d4ae5455833efe0539c7"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c3640b78c52caae41034980b2280579c6bb2499a4a4bc6132342e4e4785fd13b"
    sha256 cellar: :any,                 arm64_sequoia: "8c21157b4335e3c97de381021b0a4e44002d04114b0214f4cef7429a0ed4e0ee"
    sha256 cellar: :any,                 arm64_sonoma:  "b5ff45c2bbd4247b053c2035769d4f9484937c581c069545b9f260ab6b14d201"
    sha256 cellar: :any,                 sonoma:        "155c94239fac16860061cdc20b9ee40b691254e25004ee12544fa9bf0af02154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d67d8aaf2c7eeba5e349cab8d7d26696d4b56209302919bc7125082570ac386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87fd8a3b22acf6318d2b75ed308a1a0afb924a3f9255d74aa1b4a1f5491fc569"
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
