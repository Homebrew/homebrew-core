class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.10.0.tar.gz"
  sha256 "18617de29ba4d96b3c4b17139fc3b0fcdfa0adb205cbec96afb817b7981a33d2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd339120c5192e2febf5a034c06bcd5349d090adc078d1053b8b790063cc132d"
    sha256 cellar: :any,                 arm64_big_sur:  "03bdfafe3b268c5259cbe5983460525b57519c986aeaf6f82403986705319898"
    sha256 cellar: :any,                 monterey:       "3eed3d354fc4c9c6ca695d3d44bff542c4eef625d731befea02823429a30fb8b"
    sha256 cellar: :any,                 big_sur:        "7032cb5cf09e1026b9595f260dade8a64d810dd562b9c13ba7b9fa2eb565a57a"
    sha256 cellar: :any,                 catalina:       "8db61113c1f5df5e5a9f095598d02355338d5ef9404b8fec193f5d8a23b5b18c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e8f84a5f1697ada248922f29d40751e4aa7ab5980b282de9fa31ec5f746a32"
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
