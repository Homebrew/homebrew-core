class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "516663b62b9536cb18e6d8eb69470a5b6560f2890e010e8a3d2e8cfc65df9497"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a79b08c98281b24328007c41a8dc017f8e2f2ae817c46b4b034d1fb88c89089"
    sha256 cellar: :any,                 arm64_ventura:  "d70b8892fdac34914070401ca35119f9320ae38ca8b9a59344c82cd542987a5a"
    sha256 cellar: :any,                 arm64_monterey: "d7317dddb669a5c449d3e88d3bacf2bf1ec15c67774f37e2c08f95e576a03973"
    sha256 cellar: :any,                 sonoma:         "a9bffb6e0b6716331b42f88169ea70a83df809693a5f4160b129612d7c4e11bb"
    sha256 cellar: :any,                 ventura:        "9cde5088801cf98dc9c67347413047d053811544f8f9d4614a81f42ec1937e83"
    sha256 cellar: :any,                 monterey:       "2d4ac309c37df67f096044d1e4834a55f29a200088468e35aef460fe6f1bdab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ba63cdc9a47fb4faa2bb3a18c678289eacd4cc89349e29cadbe457926f8967"
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

      assert_match "Please login to Spotify", stdout.read
    end
  end
end
