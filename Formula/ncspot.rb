class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.11.1.tar.gz"
  sha256 "cfd8d0ea65321652cd00c91b47aaa52bd073bc4afa7e971b8f0e84e0f80eb9ff"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5de49723a911fbe93447139067a1f17039e50286b4641d16ea22f9743679fa51"
    sha256 cellar: :any,                 arm64_big_sur:  "7e22324721c5f32844fac20640c93657c7b0710cb1f9af145ba7db6f15eaf680"
    sha256 cellar: :any,                 monterey:       "ea22cba7b4b2c8e3b308a5944b4112118115716c64618e4314eb96829969ec25"
    sha256 cellar: :any,                 big_sur:        "8c15bb01c26e4576d78459fd49a4ba266264681784870792c9d38bb10d972e76"
    sha256 cellar: :any,                 catalina:       "2ff063e7be4dcafeda1da2385c4a210b0f495009537c3e4a8abfce2829f874b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f067f2412bea915e08730011e2770e8500454c81d8c9321a3656ba6f61a80e40"
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
