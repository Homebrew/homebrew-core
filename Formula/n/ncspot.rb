class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "11555a61be381afa6196b0603d12ea34ee0c6e1660d7c586d13927f3e5ba802c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "550dd0374f89b19ec42d30d166eead73d38681c7317fece9af40757b36ec413c"
    sha256 cellar: :any,                 arm64_sonoma:  "fdc0d374b07983da672dabd0c0dd1a7fdfca47b69f4c346d53f408b16224058c"
    sha256 cellar: :any,                 arm64_ventura: "30da4cb1e0c494bb35a115792ae58efed2e14075f6da9aa87db399d0445e1557"
    sha256 cellar: :any,                 sonoma:        "b9cb4a5b28d90399618594b3f6cf0d7e3032f56962c42b8a1a8ddb0ec2e847fc"
    sha256 cellar: :any,                 ventura:       "2ffab85ac8029a9406c7d3604f91b1ec56c27d377d09ab46cfb98fa7a1bdf614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beece05f5b43cf0f7df06edfd81a0ba07904ba1be052b4a7fbfb756f823096eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc62314bdc978974ec4f7f75a925189066309ad2ef83543efca8efc47ea5eb1f"
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
