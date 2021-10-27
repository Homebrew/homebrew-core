class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.0.tar.gz"
  sha256 "81655d9fab4903c6ac22321f1a6801aaedfbd88d4f5f768ae8303104fa904a53"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0e572b5014e3726b195f04926b9d530803793e8975bbef6d17ffd5c45c36a8c8"
    sha256 cellar: :any,                 arm64_big_sur:  "12843cc64096426fee19fce3fdb616415d380556b2a11ec20eb1e999905d8694"
    sha256 cellar: :any,                 monterey:       "5f8b9c87867bb5a2d5f7d6ef961fe4a9d87d4a5adebd1da50cc65eb1805c5725"
    sha256 cellar: :any,                 big_sur:        "63685a25f9e6ea6792cb736d693a252f52d76525000146f3e5c69c1eb7ba841c"
    sha256 cellar: :any,                 catalina:       "3c76d712a332dbc693696fa8d909d7b1b82bf9b0c9f352fbdfafffd33e647594"
    sha256 cellar: :any,                 mojave:         "d00e9826499e05c5a234c0cfa352ca463a50097de446d5f0df6655de5e79fd33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f67547aa1fcf968278076dba255471bba2ed77265edd91de0b2f66bcf8ea31e"
  end

  depends_on "python@3.9" => :build
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
