class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.10.0.tar.gz"
  sha256 "18617de29ba4d96b3c4b17139fc3b0fcdfa0adb205cbec96afb817b7981a33d2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba5d74c03e1b8629cefb37e3f9a3084f9ea261d782227183861a68e9313ed68d"
    sha256 cellar: :any,                 arm64_big_sur:  "301b46feac963a022209b751a50f9554a8455a4200289e44af3bd9d138857be7"
    sha256 cellar: :any,                 monterey:       "00d1757333e950e11f6e26de41322cbc603d227db8e351ba8e383a967e4a56f1"
    sha256 cellar: :any,                 big_sur:        "620941a6b33f2522fa1043b32e953e832adf439ebb283cea28335429d681df84"
    sha256 cellar: :any,                 catalina:       "f7ee58e798a7b2e0b8319f3ce87767acb092401186c14b22f321897c7d4a90bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4761a4b43e68e4f7db6290b0af972d87cd66c09be802b90279d9d2a86916bd"
  end

  depends_on "python@3.10" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "portaudio_backend,cursive/pancurses-backend,share_clipboard",
                               *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match "portaudio", shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    if OS.mac?
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "Please login to Spotify", stdout.read
    end
  end
end
