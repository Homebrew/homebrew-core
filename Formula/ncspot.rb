class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.3.tar.gz"
  sha256 "ed873d007ce356e8c6eed56226533b686682a98d2a37487668416539d4e10e78"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34972b606fbd7827ad5fd7a19edeab4e96349ee88fe7b289354ab5a6f1c26004"
    sha256 cellar: :any,                 arm64_big_sur:  "9766c41f7abe48243f5c5f83ff46dbf612f92b542504c606d2679d1ffa0e99ff"
    sha256 cellar: :any,                 monterey:       "6df4db6cc9fc2537abde449c2b13c08067d61c7db450b015f0dfeff60dad3920"
    sha256 cellar: :any,                 big_sur:        "bdd2bf1311569192b2505a83a75119a34ffe584b69987b46f10282a9e6cedfa4"
    sha256 cellar: :any,                 catalina:       "42eaf31c32326063b50a8233c9cf37fa065ff00bd7a52f81915640390abe66f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96c4e5814a0c5a9182c74dec926f2a504f765f663072eebca2e84ce0bde87ab2"
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
