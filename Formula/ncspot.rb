class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.3.0.tar.gz"
  sha256 "9dd6c0f3183a25e4297023e308b8d995c833b82e01bf6cbb803d4f3f41ac6556"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "1920c8f0552f2258d1da08bde9664ace319817ff05338135bb3e8cd7e2181270" => :big_sur
    sha256 "d324eb8e68356da802fabce2db3485f963c7088a8bef148682a10ba2344b88fa" => :arm64_big_sur
    sha256 "f796c4632dce2dcd752811e3184e210b45bba1bd447f652a4cac3763c67e3922" => :catalina
    sha256 "60a9b2c1ce1ed2829cad3b0a9f69be2279b1c18eba8cb104f5d9d36c74410943" => :mojave
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
