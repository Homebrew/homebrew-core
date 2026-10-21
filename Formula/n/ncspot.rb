class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "08a0be7e099bc40cf087a4ed8665a425c345a0e83019257d7c4affb7a1bbb881"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "601a15aac0b178762474cb693263f0d3a17ec5ec22d6c42390c0077bdd885e4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d4099326c04a20ad8e68a9e9902d84a86f7424eba5d1a321c57790d19bc1e9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b300e99c8ddb85713908f4db4acfb62ad4658a7db121396d788c7a371abbea9"
    sha256 cellar: :any,                 arm64_linux:       "fc9ee9a39b15c63fa86e18683c4ee1dfd0db320a418db36da61f61b12982c828"
    sha256 cellar: :any,                 x86_64_linux:      "74765773542a6bbefec293e8e80e130c43e32eca08a4e40daa3c9c560771dce6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "openssl@4" # Uses Secure Transport on macOS
    depends_on "pulseaudio"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    if OS.mac?
      ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path
      args = %w[--no-default-features]
      features = %w[rodio_backend cursive/pancurses-backend share_clipboard]
    end
    system "cargo", "install", *args, *std_cargo_args(features:)
  end

  test do
    backend = OS.mac? ? "rodio" : "pulseaudio"
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match backend, shell_output("#{bin}/ncspot --help")

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
