class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.13.0.tar.gz"
  sha256 "35210f8237a20eb894dc6b7cc517e60c82c2e93ff5940c267fe0bf673eccc411"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "32aa26427656bc2d116cba446efe7a91d6bb1d2af0781497b7b87e1a5ff01a1a"
    sha256 cellar: :any,                 arm64_monterey: "eeea5b4123eabedd64d32f5e64c507c446126ea598e28fa52a34cbc36f7a0715"
    sha256 cellar: :any,                 arm64_big_sur:  "622e6514c18b3d48a746f3b337e1a93d239570bb70761cb36e76a669a8a732e9"
    sha256 cellar: :any,                 ventura:        "a36427873618b3e0eb8f5cf237a8d8cdf8a289f3f12363004bfa7111d0ea7273"
    sha256 cellar: :any,                 monterey:       "2a7e7f3b587a60a0a130fb7c91cd20709be426844243435f7b55167881d5cf20"
    sha256 cellar: :any,                 big_sur:        "f6f27e8be0ea74b52df97aba66e231121faa3d00946171d2da6c64a24da3ed19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def5b0b8f8a1a1d1c35996321aca5d7a2e0368dc418e10fec1b8e288ed4c7af4"
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
