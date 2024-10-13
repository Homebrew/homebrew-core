class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "010b12172b85e6ae0eaf60ae0ab923580bcca0b132927b39c2a2fc878cb5e6a7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "60492e62ed0ad866a045fb13e45fa47a25d04a135a68c11da91a1b55c9778e0c"
    sha256 cellar: :any,                 arm64_sonoma:   "f35e1f05345078613107ce8a6575aa844fca53cee6fba089073c68a8a42dd295"
    sha256 cellar: :any,                 arm64_ventura:  "d5f059902cd839d2cc48df038fa5d78939e078d700577600ff48a3732e7e8b36"
    sha256 cellar: :any,                 arm64_monterey: "4f0d88861c7d77261f155e07c2b0a3672858f98a5d91146f7c399420af247f76"
    sha256 cellar: :any,                 sonoma:         "a30496f729f77e6cf290295f55371b3ca7e4d3e37378d9d0c7b125431bd861c1"
    sha256 cellar: :any,                 ventura:        "c89a281ecaa85cce097b7e26c4a09ba296e50d6ea4a7a07643db588417fea58b"
    sha256 cellar: :any,                 monterey:       "35779c754e4dbf665d935d823dcc4bce25ab38771260ded056796279c1715acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93644e47a7c8003c11b11ce509dcc10600a9279ccb5e13079ddc1f507c631cef"
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
