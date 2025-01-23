class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "6bd08609a56aa5854a1964c9a872fe58b69a768d7d94c874d40d7a8848241213"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "64310b2e7b96ffc398d6ac9ddb6edbfef52e85fcaf8b3fbcb581a0854dfbefd7"
    sha256 cellar: :any,                 arm64_sonoma:  "ec7c3d1571ed3d1f1a0a88af8cea76908cff9190849c054aca2c0578c351043e"
    sha256 cellar: :any,                 arm64_ventura: "736a66218ed21b9af8e91d41493a6038e98f3f698f6fc3e278165ff914c83a8e"
    sha256 cellar: :any,                 sonoma:        "c1e75e47c8b6bf6bd659fb2feb0ebeb7c9498ae4301dbbf238abe2abb6719ba8"
    sha256 cellar: :any,                 ventura:       "75ea8b7e93ccdbb1e594f81a4803db41709bec43efebd1c11f829939b3077f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b00c406a0f0592f862c596733e4cb69abc5d5352dfacf693736f392cca8967f"
  end

  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "python" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkgconf" => :build
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
