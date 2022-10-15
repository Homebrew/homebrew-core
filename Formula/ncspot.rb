class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.11.2.tar.gz"
  sha256 "0fd9696e13912b906605e9972bf3b2a8a68688cce17478353713550801c94fab"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f30fd80f102b699308af9cbf415697702946bf0fca53f46d661a2a3011677142"
    sha256 cellar: :any,                 arm64_big_sur:  "a8a3686e504ab9b8ebcec00b55994f3ebd8517d0f91a9ad4779363d4a843af09"
    sha256 cellar: :any,                 monterey:       "9c619d17795d110fc807fa4c8679be8cec2c946666865561de002c214ecd2cfc"
    sha256 cellar: :any,                 big_sur:        "94491388e9f0a62f56e1c89cdd40804df821beae7e9764fea9a45c2679094492"
    sha256 cellar: :any,                 catalina:       "e619708bdf21ebff7d72f21c941608955328c81d3b724a5680c6bc7dfe92389d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d91c74aedcee3583012804ab60999c9692ba06bb4e598fb8ae0966901d49f5b2"
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
