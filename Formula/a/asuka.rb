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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aec6df40ed09e3ffa39407f67e6b5ff4370dfeb8e3a16cca8a0504e097d631ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "32ee0da95789720132c1d861f2d3123ad212788d9146555e435a96527bf7bd3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe4fca3a8b96744b6b0304c3cf5cdbaf22a0ed7ec822d6e783b670a4c1869ac5"
    sha256 cellar: :any,                 arm64_linux:       "83fd646a9af29c9d6e407133fa9613c9288980199b9e0992381107d8bd49db37"
    sha256 cellar: :any,                 x86_64_linux:      "789d5787d195d510189eb4a4c4ba5a473a1b5e563942ed5effc8e03fb1c62937"
  end

  # Last release and activity on 2022-05-05
  deprecate! date: "2026-10-15", because: :unmaintained
  disable! date: "2027-04-15", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script -q screenlog.txt") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 43"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/asuka"
      sleep 1
      input.putc "g"
      sleep 1
      input.puts "gemini://gemini.circumlunar.space"
      sleep 10
      input.putc "q"
      input.puts "exit"

      screenlog = File.open(testpath/"screenlog.txt", "r:ASCII-8BIT", &:read)
      assert_match "# Project Gemini", screenlog
    ensure
      Process.kill("TERM", wait_thr.pid)
    end
  end
end
