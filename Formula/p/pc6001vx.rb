class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.13_src.tar.gz"
  sha256 "2bfb323ce600dd886d9370fd0d53678df12fbcdf6ddb4510e7dfd0816fa22616"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "769a5b2a309fd10d4ba770bd25182cf1e1c8dbf4d7af65a2de76e0563575e6d2"
    sha256 cellar: :any,                 arm64_ventura: "39aadcf264bf130f7cb6144bd5f3a7e2ed9f25923e5973e5c36db26ae0e3d2f9"
    sha256 cellar: :any,                 sonoma:        "59231b8d819f5913f4c2127052e9f23949d92176ed9d0319d6bc9f103c00363f"
    sha256 cellar: :any,                 ventura:       "75434a1fb02b83e35412c8d21ed748736cfe67dc582a57efc23dded4a2af837c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96c548cc860d660baa98713bf5750b6d1282bd9b9ff45f15343a262247a53ae6"
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
