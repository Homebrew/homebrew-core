class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.10.1.tar.gz"
  sha256 "7c2ed75bcf75d3da751bf6193b3a70266f41b953e840042b3a294f221a2d59a3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "badfcc15f940543377bfb251366c496e738c17d6439f42ad87c1b9136a015bcd"
    sha256 cellar: :any,                 arm64_big_sur:  "f5d455c24dabf7c4332594cda08229aeb6d44519ea09c4305cb36ea5d0e902c5"
    sha256 cellar: :any,                 monterey:       "8330f8716034bdb46064760984bcb999a18f970c71d225898cf09bd0b6581dbf"
    sha256 cellar: :any,                 big_sur:        "e10b847792421f6a4589ce2b9843cf9d84c1529956c1a3fdbd75c8b9db07a6c2"
    sha256 cellar: :any,                 catalina:       "ea70a1d644f906cfe55b1831bdc60655d4459d24bdecd13465b0a7ffd0c9f72d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52bc5e339cc57f3fc9c517c2e6ef35d904fb13672ce372b52cab88f28a500f3f"
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
