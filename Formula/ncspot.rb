class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.7.3.tar.gz"
  sha256 "b5e558279b6212d86face687220b85808b7d105ac678c2dbf8affd9ef3002e00"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "47b1ae31cf96c8a265ad98a2b5d5c69a521a94fb0b15c2cb550e9647ee995a8c"
    sha256 cellar: :any, big_sur:       "5d71fdfe922b2ef8ed1dea34f06fbce1b10f50e7a255f047c9b07f3c4e3d265f"
    sha256 cellar: :any, catalina:      "b09b77cefddfab774b14cea355a5d8cfca9cbb4b17e8a379af2e415537a9f8e0"
    sha256 cellar: :any, mojave:        "b86301b5fbc032455434ae2a1382a636db16cb89268a99a0e32151742307eb3b"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pkg-config"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install",
      "--no-default-features", "--features", "portaudio_backend,cursive/pancurses-backend", *std_cargo_args
  end

  test do
    stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
    stdin.puts "stty rows 80 cols 130"
    stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
    sleep 1
    Process.kill("INT", wait_thr.pid)

    assert_match "Please login to Spotify", stdout.read
  end
end
