class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.2.5.tar.gz"
  sha256 "568e8a586f7a374ec15b57c442e5535ded10b5232da36d1a1692e793ca849faf"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "aab5f47235ce4e64ef03154b502f44d85dbaec1c819d8c0ca74d0109d1b0dbd0" => :big_sur
    sha256 "e9523b0ad8cefcd03afa277007a2cde3c33febe04fa962bfe5fb30e38db5ca39" => :catalina
    sha256 "0cbbde0a060413e72d873a2a63bb2bbb094e7d7b9d3835a1d6493745b3d6a7eb" => :mojave
  end

  depends_on "python3" => :build
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
