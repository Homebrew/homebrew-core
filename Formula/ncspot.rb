class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.13.3.tar.gz"
  sha256 "316995d5bbef59c7a8699c8e7c3b3bc7699a38395a7d3500771abe4ca51b4d50"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d912713dc057a1b1b95957850e71a88d4a382204ff60718f8b14fb5a1986e4e"
    sha256 cellar: :any,                 arm64_monterey: "807465b0d1942c6971f89b1b049bf2cd6c9c1b0890fd73e0dda23d4739f148b1"
    sha256 cellar: :any,                 arm64_big_sur:  "16d0072ddda73d202cbb65409197c00238a504869be436617cdce84677454cd1"
    sha256 cellar: :any,                 ventura:        "ac7da81c028c0fb4dab99dc7978b4c2d9122c907ee34e1f242a3eba85b974f93"
    sha256 cellar: :any,                 monterey:       "40076a581f28eb6dd56007ab237a3db5684f061f7243896bfa63efed7a6dcd54"
    sha256 cellar: :any,                 big_sur:        "23462cf8974a2833674a31f24dd8788ad3818a78a3390efdf264088b5ab090be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb49a2a675621273cb2b7023a27aa378825150a9b9f8123528be5c737954e6c"
  end

  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "python" => :build
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
