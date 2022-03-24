class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.7.tar.gz"
  sha256 "6a7dec42d7ffde7d455b75dbc846f34463ae1e3c9bd84669382e90c4d1b31e3e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bb28fc1d752bc47726580bbdcbd7bcbdf4ec4bcc58794e5cc63e90de539979cd"
    sha256 cellar: :any,                 arm64_big_sur:  "69475b4ad3a10ad84bba6e275bbc1ce763e39c191f28f41c8d664484687e0ff3"
    sha256 cellar: :any,                 monterey:       "6c6723b49e16fdec85aa480a989af15e50738f88dc11d8790b865497b27082b3"
    sha256 cellar: :any,                 big_sur:        "c25c9486e75d94d3f490583a991fd22b06783fc741a0a38e65f17e7f6fc31a76"
    sha256 cellar: :any,                 catalina:       "30fddfa84c0d0488f635238f36075a5fd4e16c9aa3a9b2aea91f4d7359e46228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "657b5b38daa6a97e3ff595e84eb593dba769816773c70f4afa1a33eec2c793f9"
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
