class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.4.0.tar.gz"
  sha256 "d43785832cb3283aa8969b366916a2cbd72c5511b6d429aaae306da5287caea6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18e6e5f4c39f6b98a58ac1f0ebafa1d55e0c3a767dd43e5a13494175e34c8f29"
    sha256 cellar: :any_skip_relocation, big_sur:       "e18c594f6014ea5e02b00a8393d7f34dd3f7f52ce51c8650105709ae1966122b"
    sha256 cellar: :any_skip_relocation, catalina:      "6e503a3e3dc1752b3a034c29bd69f7db7e64b16475e7e1496abd74c1e2038dea"
    sha256 cellar: :any_skip_relocation, mojave:        "35a09c9fe20a5a3a5e02e274d9d25b551274953b939b1b9995451d03b68cbf2c"
  end

  depends_on "python@3.9" => :build
  depends_on "rust" => :build

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install",
      "--no-default-features", "--features", "rodio_backend,cursive/pancurses-backend", *std_cargo_args
  end

  test do
    pid = fork { exec "#{bin}/ncspot -b . -d debug.log 2>&1 >/dev/null" }
    sleep 2
    Process.kill "TERM", pid

    assert_match '[ncspot::config] [TRACE] "./.config"', File.read("debug.log")
  end
end
