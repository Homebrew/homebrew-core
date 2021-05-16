class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.7.1.tar.gz"
  sha256 "24c4e5865d276c3bc3684cd3fce474f0835859a28ab7e6ca24d0f13dc4d430fa"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1a78663c9d77b251d550fd2c8e14426f84efad1cc0f6b565c1df8e64897e4aba"
    sha256 cellar: :any, big_sur:       "a2f54bb9faaea6fc52a055805dfd203626c7992b629207ce4ae56a8d44972551"
    sha256 cellar: :any, catalina:      "894b201a52abf092b894323d4273e105d2025c20572ccc1d828e269f26ce2bce"
    sha256 cellar: :any, mojave:        "57b043fcf15a1faf5a83efd3a69557498ea5fa92df9dc422d1b7a10e27bd5b45"
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
