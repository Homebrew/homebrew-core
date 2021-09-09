class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.8.2.tar.gz"
  sha256 "86274e3115d11efc5cd14389f0f52674ef1353f2943304b9b014afd7f16122ab"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8117c43330eb8b31428e6a1bf7b9a310b23ab7f95febb93ae173d49543735d0e"
    sha256 cellar: :any,                 big_sur:       "f1eb987148a0db5acd0f5278851ac5432fabd53687a74f3fda3dbd7bc80dd1bb"
    sha256 cellar: :any,                 catalina:      "c47a959de1dbfd45396162f4eeadac9cfe2aac41de20ab8e760e4cec589a9d75"
    sha256 cellar: :any,                 mojave:        "d2bee764837f04d29f050fabf1b1d6430ffe6ec8af2cfb426ac8670c8678549e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93b312fda3916f507d5b83ce463fa20755164092a8a2bdd2b51598330fa22e20"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"
  uses_from_macos "openssl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "portaudio_backend,cursive/pancurses-backend",
                               *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match "portaudio", shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    on_macos do
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "Please login to Spotify", stdout.read
    end
  end
end
