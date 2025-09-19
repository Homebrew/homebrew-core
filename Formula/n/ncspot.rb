class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d767fbe4c742b18a3ef7203162cc55a0976e07e478295445a5de1660666e2f15"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb345cc7b697d592d7dd4ad42a3bdca869d49e0293f59deb7c51058517088cfa"
    sha256 cellar: :any,                 arm64_sequoia: "9bf2c2f4ac84e00df974d4478941442f78e91c14d34bfcc10c1706f19d60f093"
    sha256 cellar: :any,                 arm64_sonoma:  "11100b8b9d9ff8a214d127197a1ed3670d445440ff2a80cedd663ad490cbcf22"
    sha256 cellar: :any,                 arm64_ventura: "da02d72a547b95fe98bcfa287fbcd55835b0b6b6802afa0da2a896cb47fd0080"
    sha256 cellar: :any,                 sonoma:        "13cab273ef6716f5905cc04198297e3c21aef481b16db50456b16f93c7d2d01b"
    sha256 cellar: :any,                 ventura:       "4b10b26ac782aad4d90d852c38b4edc794115ab68ecc629da9840b9f312f6e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d174716921203688315c6f8c450796a9ee2694755ba9a440e578458bb475ec1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ae43cf3031bbafca5a82cad5a96b1fc52a0ae04765ea6e11fb5199a7a57bd7f"
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
