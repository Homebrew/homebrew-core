class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.4.tar.gz"
  sha256 "17c300194de48bba1aa75801ede1d9a3a6e3be473145d8663e3f4360b41361e3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5e6213f97472cbf062c98ca1f535f528f527898dc8870348008825fa098f881e"
    sha256 cellar: :any,                 arm64_big_sur:  "2160ef39c07723230e7d72d2dabc9ff4666a3b1d096faf25b4dadc00daeb94fa"
    sha256 cellar: :any,                 monterey:       "0ea6723aab94789babcc5e30f170c5da238d2d1bd3601e316d7cd3cb2be3aef2"
    sha256 cellar: :any,                 big_sur:        "0b7c0c1fbec3e6ab875a8cc6c1c20f4857a3f7c0af3a6f5c4b7950d2b0b2c0ab"
    sha256 cellar: :any,                 catalina:       "7303d46c050eb9667de8b6fa83956d59eeeeb73ba12598bf3e6f64604b0a4a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de1e5d55da0e57d5ff7fee6a7e783d51b381869ca7d71d815519e90bea72f123"
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
