class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.6.0_src.tar.gz"
  sha256 "a5d5961464064f899abc50ab41c6392f8488f62d9acd8dfd1aade2b27393fc24"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4eb97be7123af4388e7be76738fcd391c75f9934986b64bc0bb57f8b4bbf3564"
    sha256 cellar: :any, arm64_tahoe:       "f58926515a888997481b36bae4a43ba78d3ba9ead362a8eb45310994b5ac2978"
    sha256 cellar: :any, arm64_sequoia:     "35f1ce08ba615c14e59996e6a3c5a4d2cf752bb056e5f57825476c4b01dd6d08"
    sha256 cellar: :any, arm64_linux:       "f8cb5a55a8883b7d9f300ba17c48db106398d6eca4079654257a67e0508f55e2"
    sha256 cellar: :any, x86_64_linux:      "37e09f4688a673d7303c795e0eadc10e97d3d50c19fb4aa39ac55be7506cef76"
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
