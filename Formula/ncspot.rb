class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.7.3.tar.gz"
  sha256 "b5e558279b6212d86face687220b85808b7d105ac678c2dbf8affd9ef3002e00"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3e8fbf7fcda473da5f7e65b53d153ba88387b66a5174cef0cc20e98443dbcd2e"
    sha256 cellar: :any, big_sur:       "c1d0d1cdec6c3ee64c1d9e7b271b3d2440492f263027bf15a8ac524912544e22"
    sha256 cellar: :any, catalina:      "e0fb78362d23f03dd67601e83c823780ead268b363a050704897d80ae48f59ae"
    sha256 cellar: :any, mojave:        "c8152b314fa9297759a163ff11ec98c37deb7954653b886f1c05c0000dbbad4a"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pkg-config"
  end

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install",
      "--no-default-features", "--features", "portaudio_backend,cursive/pancurses-backend", *std_cargo_args
  end

  test do
    stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
    stdin.puts "stty rows 80 cols 130"
    stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
    sleep 1
    Process.kill("INT", wait_thr.pid)

    assert_match "Please login to Spotify", stdout.read
  end
end
