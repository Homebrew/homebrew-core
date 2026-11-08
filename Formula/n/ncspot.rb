class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "1c90dfcf33612ea408ad7af88749ee1d4f08cc242cf887337aacff18048c1aad"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bb3e62aa21729cf77a320d01fa1da2bf1e89da64509e2763cf19e6075ce256f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3b26c770d94d045711922106ae532ee43bc58be48cb50172bf296faf16e805b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "002e88722108029f98ddbd7bfb3b852619c3d5b5fe8dba193801b05e76e8ddd0"
    sha256 cellar: :any,                 arm64_linux:       "72cdd2892e97c6c354e0e6f7e5982726c69ecb9a6d7a118377632144225e7ddd"
    sha256 cellar: :any,                 x86_64_linux:      "9ffc7ccc89a7d3cde68f73c4e1fc8316d50b02d6152ee8ed88c78f236bb94b5c"
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
