class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "244f0b37b34a5b7f832c77e7fe102b0f66382156e26395cdf7e2dedfe0d71220"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1495e856fb571c6e90a6ae0d8d742eaea52b1fb7e28bc465efa626c2c072ef97"
    sha256 cellar: :any,                 arm64_sonoma:  "b1368f6a0a50be936bfb77d8016b15987bd0ce7d10a6cbfe2eedfdc5b628d140"
    sha256 cellar: :any,                 arm64_ventura: "69da6f5e085951b6790fec996ef8e1f630d4ba65b750c856004ce0874b5bf820"
    sha256 cellar: :any,                 sonoma:        "c7c72bf0a65080bed5f7f4ff84cd411df2e55af470c291a73b57c77e9187064b"
    sha256 cellar: :any,                 ventura:       "f8bf25ff27bdf05ec1375dc1fd4d9c5b74203d66054f1c3afaf4cc3d258835be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b1f0494911ba89fe7d429f590b52788048d8d0b4700e83972e025467423a479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e6424d1b77f3d3b5bc2d0e2bfea800e34fcf97d9296f2e8861ea94ae4280322"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "python" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed if OS.mac?
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

      assert_match "To login you need to perform OAuth2 authorization", stdout.read
    end
  end
end
