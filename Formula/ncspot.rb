class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.11.2.tar.gz"
  sha256 "0fd9696e13912b906605e9972bf3b2a8a68688cce17478353713550801c94fab"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4803e02911c69a60393a168a01da8db5cf7cabd021870521e24f60804a656d1b"
    sha256 cellar: :any,                 arm64_monterey: "5e85be041e1f6282f54b2a39fb5a9a69da526fe072e2f5073d8d48a9cf64a84a"
    sha256 cellar: :any,                 arm64_big_sur:  "14f82f6c712d08f1323db0645df34e15121a1c1aaea6e0e4533d5396c9b799d6"
    sha256 cellar: :any,                 ventura:        "223cd6f0d0ef90365e81168871fc3133e823a7a5e13c5417e9ee09fed7265cae"
    sha256 cellar: :any,                 monterey:       "13b8775762c5070ee174548988d5495041cedd886dba3637257076fa6da1c8fb"
    sha256 cellar: :any,                 big_sur:        "1a77705e1b8b5b3706fee125b4e5dd098386fd78d870c654d81ba9c29b306382"
    sha256 cellar: :any,                 catalina:       "5eccacc0e822a3b1943f2bbc51ed7694ec2cb59ea902e5583167137b10d094c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d432f52dfc912a31948b811a026eb0dd2dc757d1cbb224a99d417ea13497a0c2"
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
