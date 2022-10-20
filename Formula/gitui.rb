class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.21.0.tar.gz"
  sha256 "da99defad08bd455c12398438e846aa71c160acfbcc60d06b9c852c5d7ef1d99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ce4ae54339401e508a86c1d5da21e67804a0222750190a38442a3389e447d5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b379c91b9464e72ff96a7fc32b75343d67ef7aba6de09a9c972b1236e58f0d9f"
    sha256 cellar: :any_skip_relocation, monterey:       "417c5b1af7a2473923ff063603380e95f8b04e5b5a6ae4a35a737291d5063bd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7ceec42efc13edef1776c6259fad2f59a1a4151e74b641befd9e061061eba25"
    sha256 cellar: :any_skip_relocation, catalina:       "7c6269d00a77a933f31c24e1febfe8cc8e9ad14f78f04ac09c547692fd03551d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1822fe25bdf6aa854cf4fbf676dad09cc12a424644341393b77230ee2305842"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "clone", "https://github.com/extrawurst/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
    sleep 1
    # select log tab
    input.puts "2"
    sleep 1
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 1
    input.puts "\e[C"
    sleep 1
    input.close

    screenlog = (testpath/"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
