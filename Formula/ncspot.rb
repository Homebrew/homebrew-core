class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.7.tar.gz"
  sha256 "6a7dec42d7ffde7d455b75dbc846f34463ae1e3c9bd84669382e90c4d1b31e3e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "443df99acd4a33084bf0533530f1cbccb1f11483a0247e79d93f94507888182f"
    sha256 cellar: :any,                 arm64_big_sur:  "f4a0f3505f22dac478f24bdda52e95235a96ff5c432ed9b14ecf0b2a02f33bf1"
    sha256 cellar: :any,                 monterey:       "5977b7dbde358af77e538cf4b87c70f50a029d0c7269a331918c551ec4121f13"
    sha256 cellar: :any,                 big_sur:        "faf99435a6f2b0b68ad608ce7eca5c7d48628b37c189a1e7030aa526233d63da"
    sha256 cellar: :any,                 catalina:       "aa94c644da36534645ca0b28a5a903bd800a52f4d64c0da5fcfb98456fde683c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a84d543f43fe58721fcce5694d33a3e247d3e9dd427f3a15393f145d6f1803"
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
