class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.4.0_src.tar.gz"
  sha256 "d31716ba9d2d96de9c664ed5006391e834dae54dcda574f1cf0bf7d074866333"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d8a5b0fe11cc49202f21b3775157241eb9e8080be0356ff6583820732a87e5a"
    sha256 cellar: :any, arm64_sequoia: "9866b2886c96b9810cec0e760dc77cc33a75d66047b5d064c713bbd5ef9c6590"
    sha256 cellar: :any, arm64_sonoma:  "eb922305b04df645bed37e336a35b945e8925727a08b74a27eff3735c4d8afe4"
    sha256 cellar: :any, sonoma:        "8cb2be2cd3e2e63b55caddc5af7cec469086c4e882a9b0c04c37d51df768bc5b"
    sha256 cellar: :any, arm64_linux:   "88f5c5c6105c6aec4f094fabd65c20a776762c9c5ef3a5a7333850d03c5d7675"
    sha256 cellar: :any, x86_64_linux:  "65764ea2290d9a0d206bd7815f7d6d263e817932d4273eec5c03ab3293ddc7c1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "ffmpeg"
  depends_on "qtbase"
  depends_on "qtmultimedia"
  depends_on "sdl2-compat"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
  end

  def install
    # Upstream only guards the X11 probe against Android, but Qt exposes no
    # `QX11Application` on macOS, where the screensaver code is a no-op anyway
    inreplace "CMakeLists.txt", "if(X11_FOUND)", "if(X11_FOUND AND NOT APPLE)"

    # The CMake port only links `intl` for Windows, but the old qmake build
    # linked it on macOS too, where `gettext` is not part of libc
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # Upstream ships no `install` rules and names the binary after the version
    bin.install "build/PC6001VX-#{version}" => "PC6001VX"
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/PC6001VX --version")

    user_config_dir = testpath/".pc6001vx4"
    user_config_dir.mkpath
    pid = spawn bin/"PC6001VX"
    # the config tree is written on startup; Intel Macs need well over a minute,
    # so allow plenty of time but stop waiting as soon as it appears
    120.times do
      break if (user_config_dir/"rom").exist?

      sleep 1
    end
    assert_path_exists user_config_dir/"rom", "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
