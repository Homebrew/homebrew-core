class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.3.0.tar.gz"
  sha256 "9dd6c0f3183a25e4297023e308b8d995c833b82e01bf6cbb803d4f3f41ac6556"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "272ff0ca2d15a5195b4ef3e76c90b949400aee9225983d8218e797ca00e0897a" => :big_sur
    sha256 "89b5d9d1049eedd795cfcc5068bdc043ec605d7eb971e3adde1841b889cdf7aa" => :arm64_big_sur
    sha256 "0cc47ededdba553570ca4b443e26fe66bb3419a8c76a8f748b3170eb54e4787a" => :catalina
    sha256 "765ec65802d29d0b65130d5333fdf6d0c9460204ae9f8d3e9d59c2dc2a8471b6" => :mojave
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
