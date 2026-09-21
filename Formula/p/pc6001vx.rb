class Pc6001vx < Formula
  desc "PC-6001 emulator"
  # http://eighttails.seesaa.net/ gives 405 error
  homepage "https://github.com/eighttails/PC6001VX"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_4.5.0_src.tar.gz"
  sha256 "ed2599b0418a5d5a13a23546812c44168fb7bc222e2dc7e02d35b46f63e64087"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fc9502a41d16f991df3c9620047661add39a2440ca55811efef9fa078b776c20"
    sha256 cellar: :any, arm64_tahoe:       "7484b1c6da6702570861a93057d07c9f54c3e1f42f1e2ea9606a07d30efca5ca"
    sha256 cellar: :any, arm64_sequoia:     "b7fe9332e751381c3f13921bd0a9519c068a3770af219bb66f4f71ba6694b6a2"
    sha256 cellar: :any, arm64_sonoma:      "f88e1cd99e8f43b781778f784fbf76fdf5657269e844302e5b36242a17f96881"
    sha256 cellar: :any, arm64_linux:       "c8d3fe21b698208f5ebd1a0599cb65dcfde99efb2e054af706aefd311552cd8f"
    sha256 cellar: :any, x86_64_linux:      "86804ae656cffca115b4ae13ffdf976d2a1bdc4dfea3a7c4d798b7579b3dcf2c"
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
