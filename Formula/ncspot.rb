class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.6.0.tar.gz"
  sha256 "a2a779bb4c917e89257089c6063d594178076022807c9a49153e313cb0204ae8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a7a41bf0a58e028757e92b5981331165339c92836d56442d140457712dfe2dd2"
    sha256 cellar: :any, big_sur:       "2212d0d7f5f9d4fd8e8e5cc69db8ec7536c5e39febf3310beaf63b17c4c85865"
    sha256 cellar: :any, catalina:      "8e09c7217d43951a05d2f3140b91e60ecd9dc4fabe45c4e6a9db6a3add5237db"
    sha256 cellar: :any, mojave:        "9879e85467ee146812a17869b1776030f004641f2dbf0a9ce9bc4650995a6b3c"
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
