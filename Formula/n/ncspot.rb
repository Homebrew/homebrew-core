class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "0df821a5ea70a143d3529abadd39bcdd9643720a602c99a9c0f8f31f52b4a0fb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d81b112192c5b91744b9fa5ea1a86ee32e9497c383ffe1475ea84e7ada4e9e98"
    sha256 cellar: :any,                 arm64_sonoma:  "785bd8afceae248fcf3706021b5d6985969fefc7a528e696e134d13790be726b"
    sha256 cellar: :any,                 arm64_ventura: "35fbd1b2f0d90a3bf86771b6f2095ae54a6ec990b0e4901b41550b0e795f30d0"
    sha256 cellar: :any,                 sonoma:        "59630a6a71c3eb801f13a16015e8ddafd5055f4fbfdb362f3f51870ab77d76d0"
    sha256 cellar: :any,                 ventura:       "313bdcac72e6b844031500f2ab90a7a942242d63d5f51d25ada79cef549bf909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d0f5902157b9749d35115c02de88af65b8a616b5ac304cef1e1585faa1fb9de"
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
