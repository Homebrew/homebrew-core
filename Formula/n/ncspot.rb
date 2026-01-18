class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "d60c04c027dddbc57cbd9bcb23ec4967b4ae7330a280a7a5f6b77c1ea2cf8c99"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "984223fd43a1f0ca585914151c89b1cd0ceb6bc58d11449c926f3b7fc575ca8c"
    sha256 cellar: :any,                 arm64_sequoia: "c7884c9e55c87f00ac1a74a07debf5fcc96980d05f485a3bf689467b9f1b0c34"
    sha256 cellar: :any,                 arm64_sonoma:  "5257c38aec7b81e4e06de13ac7b50663b4e8e93a59b5537537a8bb1a8726d24c"
    sha256 cellar: :any,                 sonoma:        "a838779e650b777ac442c8931077b13263c298c956d4a0dcbf9ad4447d1b25eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0b530ee6c7d3d2f4d793fc9b77a79291275fa1032cf7d177a1446f53304b237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0603acaaeeb0adb231213dc8ac507b9fdb7cb3ffabd93a746f2ce29a8e7258a3"
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
