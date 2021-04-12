class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.6.0.tar.gz"
  sha256 "a2a779bb4c917e89257089c6063d594178076022807c9a49153e313cb0204ae8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3fc0653202b4e9ce88ab297d3fd3ff20588d8cb4d8ffcbb2ee09d6d20e79e40"
    sha256 cellar: :any, big_sur:       "6515b747bbc12bbe1aa9f0e76fba2cf44e9ceb0912ff17e1c9f648aa44ad9557"
    sha256 cellar: :any, catalina:      "0f99884b730d45351f68bc3095234648b2b5b7662a97e5fd4b2be770023d8d0d"
    sha256 cellar: :any, mojave:        "5507e6fc089a50362720bf8a5e8dd13e2e573733212832e4b322f2311235fa6c"
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
