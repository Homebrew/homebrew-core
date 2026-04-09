class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "26edf6f1861828452355d614349c0a2af49113b392d7cd52290ea7f180f6bfe5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "776c4c58d07000bb93cdce6aaaf28a6fc630376633f37b74e02d910272cfc066"
    sha256 cellar: :any,                 arm64_sequoia: "ab7e954ab6379a59d2f5bf78894916181a88e6e212474b2a815401e17b10d2af"
    sha256 cellar: :any,                 arm64_sonoma:  "2be213e238f4a8bc284ddc4431889b16e1060744945717edf0814f17d84e83f2"
    sha256 cellar: :any,                 sonoma:        "d95fee3c6dd6a833b19e69f07504b70632c8b67210217a0b09505bd1e92b9508"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97eb8a7e13415b3933d3309d886fa13db7252822803a9888a64b674abb4c8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b10d3c534c0c533ddbb48ba9a746da1befcc71b4444ea941641b23176d0738e"
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

    features = %w[portaudio_backend cursive/pancurses-backend share_clipboard]
    system "cargo", "install", "--no-default-features", *std_cargo_args(features:)
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
