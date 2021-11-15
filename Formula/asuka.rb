class Asuka < Formula
  desc "Gemini Project client written in Rust with NCurses"
  homepage "https://sr.ht/~julienxx/Asuka/"
  url "https://git.sr.ht/~julienxx/asuka/archive/0.8.3.tar.gz"
  sha256 "1305d65e07e83fe33ca102637fa27f8dafae9a9aaa436414c29532c4ed51c6ea"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0569256aff79179b0e44f42bd4bbcf511aa3933ed1578ed9b7c6b2f140419b43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b5bb131f128e4a410d01615c1ea994365d2e31ac96109f4907cae513675526c"
    sha256 cellar: :any_skip_relocation, monterey:       "0ed9621d904ee83efd90bd1b38d117f262d7b0d7cc150d0bcec48be30ccaae4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "26d7c7e0216db2d6909b0770e55dc92f717558aaa3ec8e7330743a58293f38b6"
    sha256 cellar: :any_skip_relocation, catalina:       "4b44603a1aea30e38c0396d0a59f4d6ed3ba5c10919385c09a58f698da340f5e"
    sha256 cellar: :any_skip_relocation, mojave:         "b75723fc27ad5f002a9757371d3d76a362e3690e1d434bafb033f19d4e14da98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbf79e00e2a48f4d9f3356bede6bb934f2f7a17306bcce5fbb3cf285f6b1cd7"
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
