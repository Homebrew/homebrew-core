class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.13.1.tar.gz"
  sha256 "51394f0a4f75c6d6273f1a98be350dca3f50a8ba21e5b563e85b08b9da04af89"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1419d937f72a7bb796dec58c97ece77c950f2144b5e64cef312087db51f8596b"
    sha256 cellar: :any,                 arm64_monterey: "450a5b24bddd3ede411a5fdc467d75a15578b1616f55d28844b53f9a00552a93"
    sha256 cellar: :any,                 arm64_big_sur:  "bd0e527d49304e73fd1ba3a94ce4a5c00959005ab78cb41fa18aaa72d710affc"
    sha256 cellar: :any,                 ventura:        "a9f41c291497d3f734828af04c2dfa682603f011b5e37c7ccf1322e5800cf355"
    sha256 cellar: :any,                 monterey:       "2baeb731e47275da1e3cc56fac9591bb5183ac60cb26913a680237442c9ceaf0"
    sha256 cellar: :any,                 big_sur:        "2e726015639149e25e8c47aaf634b43dc5f37aeecf937e4133f02c3a49eee387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf9cec94ffa370ff2fd85f71933c3b97d230f3a55bfff06847568b490215c781"
  end

  depends_on "python@3.11" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3" # Uses Secure Transport on macOS
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
