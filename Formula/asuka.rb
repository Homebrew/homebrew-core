class Asuka < Formula
  desc "Gemini Project client written in Rust with NCurses"
  homepage "https://git.sr.ht/~julienxx/asuka"
  url "https://git.sr.ht/~julienxx/asuka/archive/0.8.1.tar.gz"
  sha256 "06b03e9595b5b84e46e860ea2cf1103b244b3908fabf30337fcdf1db2a06281e"
  license "MIT"

  livecheck do
    url "https://git.sr.ht/~julienxx/asuka/refs"
    regex(%r{href=.*?/archive/v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6c71e20910385795758563119bf66206b6507fc83a6ed70f39872e45acc47415" => :catalina
    sha256 "8143fc7187b559648f9c7e1f8c53a6f6c9dcee316ba623480abbe1fa6ccef90d" => :mojave
    sha256 "1b483ae24e861978bcc9487794ffb27a79edbbcb0a1821b24b9e62b5ee3c9c0e" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
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
    assert_match /# Project Gemini/, screenlog
    assert_match /Gemini is a new internet protocol/, screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
