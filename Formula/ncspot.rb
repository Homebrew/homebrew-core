class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.3.tar.gz"
  sha256 "ed873d007ce356e8c6eed56226533b686682a98d2a37487668416539d4e10e78"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21c71396136e8daa1bba4f6ea34f74c4af4721a9a3a9bbea5ff39808e09a4bd4"
    sha256 cellar: :any,                 arm64_big_sur:  "69d970aea42cb583929d9b891d55be7eb27572f69aa01c467ecd200699cdf680"
    sha256 cellar: :any,                 monterey:       "7f98ab62645cd1c4599b23ffc01776a15786de7679b2df30ad9ebf81e5b27a94"
    sha256 cellar: :any,                 big_sur:        "6ff7355cb3faae6bfbc4ff3d84dd94b731744466e6247eabae085ae47f75e89f"
    sha256 cellar: :any,                 catalina:       "d7ff985b4307dcd9904633767a94f80f9bf938ec98bf1624131bc5c1e306ba38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "157333dc3c09586047231c0fa7443401d3e179d3225cb7c0871a2493e7515bed"
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
