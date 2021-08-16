class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.8.1.tar.gz"
  sha256 "6d08ae339dc1b1fb1e472490e0d672840030467158a5a1f7472b588e2de303fe"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9074da177ad5d0d06a1921bb72b79a2040ccc239f904c61cb9d1f4493ceb81fa"
    sha256 cellar: :any,                 big_sur:       "feb382bbe4c1fb4fa15546fcb3318db22c8477d4cc3598ba7a411da9ede92180"
    sha256 cellar: :any,                 catalina:      "294cb91373891976b22a89fa3ea29a45cde7e215f95fc29912ac672d5f76c3c4"
    sha256 cellar: :any,                 mojave:        "30b33ab6397cf7e0ec5cd58a6104c44121459e6bd953df4365cc0ed2d0210fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96cd460fe84ceb0fcb9669591abb8b467b8b6221c737bfeb99e3501d1fdfbf30"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  uses_from_macos "ncurses"
  uses_from_macos "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "libxcb"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install", "--no-default-features",
                               "--features", "portaudio_backend,cursive/pancurses-backend",
                               *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncspot --version")
    assert_match "portaudio", shell_output("#{bin}/ncspot --help")

    # Linux CI has an issue running `script`-based testcases
    on_macos do
      stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
      stdin.puts "stty rows 80 cols 130"
      stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
      sleep 1
      Process.kill("INT", wait_thr.pid)

      assert_match "Please login to Spotify", stdout.read
    end
  end
end
