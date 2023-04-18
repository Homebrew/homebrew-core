class Asuka < Formula
  desc "Gemini Project client written in Rust with NCurses"
  homepage "https://sr.ht/~julienxx/Asuka/"
  url "https://git.sr.ht/~julienxx/asuka/archive/0.8.5.tar.gz"
  sha256 "f7be2925cfc7ee6dcdfa4c30b9d4f6963f729c1b3f526ac242c7e1794bb190b1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c02f51ae8c0a6bfa92468fa67574c31a5ac69680fa9aed4d0ff56028755a16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf321cdfb82c2c08f69c1a7e48eed33d00e71c569e7eef10004ffd833c36bb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdd3adc10b5f906817abc3929dff9cb8e1420b2d91a88c5ac41d83106c9150bd"
    sha256 cellar: :any_skip_relocation, ventura:        "5403bcc45b1d57b653520103366cd5b73e2903fea485e4300740ed26438d1656"
    sha256 cellar: :any_skip_relocation, monterey:       "3f55b85765e46142ec4916bf0979283853e4442a116e2afc52282aa011d542be"
    sha256 cellar: :any_skip_relocation, big_sur:        "d943994991d51bfa95ce90f41e1cc7ad83be02e3b1117b76ed684310a22fb0ae"
    sha256 cellar: :any_skip_relocation, catalina:       "343c7a00b703c35a8e3600481d9dc54eb96bbb3f715cceb13e113f3dc1c7eeea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600e1d1324197049502dddfbce2df349657fb4108154a042c6503bdb69f24400"
  end

  depends_on "rust" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, _, wait_thr = Open3.popen2 "script -q screenlog.txt"
    input.puts "stty rows 80 cols 43"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/asuka"
    sleep 1
    input.putc "g"
    sleep 1
    input.puts "gemini://gemini.circumlunar.space"
    sleep 10
    input.putc "q"
    input.puts "exit"

    screenlog = (testpath/"screenlog.txt").read
    assert_match "# Project Gemini", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
