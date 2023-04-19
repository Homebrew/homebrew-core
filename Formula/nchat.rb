class Nchat < Formula
  desc "Terminal-based Telegram client for Linux and macOS"
  homepage "https://github.com/d99kris/nchat"
  url "https://github.com/d99kris/nchat/archive/refs/tags/v3.39.tar.gz"
  sha256 "5b3f7bd3b9c232fdd1f202ec85d89874530f2d778ecffbba403be7a568e3ec5e"
  license "MIT"
  head "https://github.com/d99kris/nchat.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "ccache"
  depends_on "go"
  depends_on "gperf"
  depends_on "help2man"
  depends_on "libmagic"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "ncurses"
  uses_from_macos "sqlite"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    setup_process = IO.popen "#{bin}/nchat --setup"
    sleep 5
    Process.kill "TERM", setup_process.pid
    assert_match "Telegram", setup_process.read
  end
end
