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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74bce9c3efdfa9d6a507bb87fd329b1c988e9e283c0cefe75352a9310f8e1e88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1921705681d406e5d5a47a061026b052fffca3b8b7994619c9279e34394891a1"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a111169f6a8ab65d73444a7fb698fa993b2c61b1ff556b84130125ec546e50"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3b6f8e7d99f9a8ac1f759b076be04f93c09d6543eef83f34fddf947549b8d92"
    sha256 cellar: :any_skip_relocation, catalina:       "902303f78522d425e7fed2656144114cd68cac29155609691dbe49184d48897b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5764867f2dfe1962695ee027633ce09e82177971712a10d96f8c9fbe60c1c1"
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
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
