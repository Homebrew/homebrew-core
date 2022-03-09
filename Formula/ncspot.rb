class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.9.6.tar.gz"
  sha256 "43f3108bffac6d735280d96feb9a49ca61674c9efebd553e1551d61b389bab93"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bd958971cad87d26689f9df43437609fb532b6cf34d01c402d8679f09b415d8c"
    sha256 cellar: :any,                 arm64_big_sur:  "a53e9def32a6cf4063587d27bd7c18d1f44b5cd5494a21bcd1307936bd97f6a8"
    sha256 cellar: :any,                 monterey:       "20c54a3e4f1c9ab56805622eba550fd1ec15258998f4627b4f558d9ac0fcff43"
    sha256 cellar: :any,                 big_sur:        "1d1584e1d2b3fdb2f49b0461a41bef348174af90bd4145f45a90c3f995351e04"
    sha256 cellar: :any,                 catalina:       "00380722fe96a3e58e9b4e0cda4e1f255fbfd403a3d405c41921c28af3730147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12dd6d810e369adb15a0e1d22ff3d1a8e7776f3eb542e8216c64af7ef51b770"
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
