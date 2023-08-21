class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.23.0.tar.gz"
  sha256 "5180d5d8fd2fe6400148d6078b4b318c7530ca6c27ea8d8c0882f2e4d9064a80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1218bad2046b1c47908914b76f203c8dac729d95871ae7845d642aefb1e8a6d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03abe4921a9512cca4ce28990efd33521ed62c2699756344ba63ee61907a002e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1f6dd5f9c553da862f2789eb97ee79051074f499b15ac5cdba29a4dcd1e4768"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a179ebb7c726f0778b947ee02a65fc81f6086f0446353600954ea09115e4ad"
    sha256 cellar: :any_skip_relocation, monterey:       "7938b3e69caeb4eb28620327ff5d27eda0583227e2bcf525d0e83715874bab08"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e904aa9b16805469e78ecb18d726750fc22278722d1a916ecceb43910fcd759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "114c4a330d5d3e72985076f0cec436c43cde3ff90d3c6f755610b7d2ac2e757e"
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
