class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.2.14_src.tar.gz"
  sha256 "8b572e0dfb105ad003d7ebdbfe0d081af1189052f362d4ae5455833efe0539c7"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44a00dd3bd364cace70e5326da1bea0f4505f154ada9755457cd36a9d697c883"
    sha256 cellar: :any,                 arm64_sequoia: "99c4cd27b6c4435dc9192a36b26d8651029bbe33648a8466150f48c073a6c131"
    sha256 cellar: :any,                 arm64_sonoma:  "6df7fb6487fe485bdc9d14481db605240933153a4d425fd141e6d04b63a506a0"
    sha256 cellar: :any,                 arm64_ventura: "5d5b3239dc60d35eacb295499dd5085a14d4c4d45a028b23598c865165a41fdc"
    sha256 cellar: :any,                 sonoma:        "205b536ca203afb6a108c1fae7da121dba540bdf0df7249836b687e31026154d"
    sha256 cellar: :any,                 ventura:       "52ddfbe92ae410daa0d1baf724a0dd4827845b5b577cedc6335f13ea850d6b5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408343d8640e1ebd04bde57db18525ae271908ae7150267d3304035d3927be4d"
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
