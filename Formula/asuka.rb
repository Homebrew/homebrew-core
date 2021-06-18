class Asuka < Formula
  desc "Gemini Project client written in Rust with NCurses"
  homepage "https://sr.ht/~julienxx/Asuka/"
  url "https://git.sr.ht/~julienxx/asuka/archive/0.8.1.tar.gz"
  sha256 "8b51eecd885be5b32e970d6cc1f4d56515960a08ed860769368859be8bdc083e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6fade18fdb60d3a3c37fbfe14b19b2befc384918c4d0899b373e28d4519f7d2f"
    sha256 cellar: :any_skip_relocation, catalina:      "6c71e20910385795758563119bf66206b6507fc83a6ed70f39872e45acc47415"
    sha256 cellar: :any_skip_relocation, mojave:        "8143fc7187b559648f9c7e1f8c53a6f6c9dcee316ba623480abbe1fa6ccef90d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "1b483ae24e861978bcc9487794ffb27a79edbbcb0a1821b24b9e62b5ee3c9c0e"
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
    assert_match "# Project Gemini", screenlog
    assert_match "Gemini is a new internet protocol", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
