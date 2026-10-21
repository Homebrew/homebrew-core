class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.5.1_src.tar.gz"
  sha256 "bd12d423ff5ab7e3eb947c1ea7fa9fd9789430bb9e28b185292dfcd6ed12c695"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7e90692ae1c6131289e84208b2115e57c1829cb988b7e0156bcd9756ffbcc0b3"
    sha256 cellar: :any, arm64_tahoe:       "1b0123eea633f126e50428d2addf5059a6966b86ff739417485a39576ce72461"
    sha256 cellar: :any, arm64_sequoia:     "ced845d3261f125f4d7362f68026ab2c9f976f95fc80fc61f7b9f62cb6967997"
    sha256 cellar: :any, arm64_linux:       "4f2697dca0cc0c149d814f2e7a8e5cdc7d7ac47a3fc91c5d204df698ad478298"
    sha256 cellar: :any, x86_64_linux:      "72532608e13cfd58418acbd1038dea5db677a4a8d3b59ebb536d0a2b19a4628b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "ffmpeg"
  depends_on "qtbase"
  depends_on "qtdeclarative"
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
