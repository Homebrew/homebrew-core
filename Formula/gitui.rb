class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.13.0.tar.gz"
  sha256 "ebf3ba559d05205e629805f60441411a0609e2a84444753cfd3a4a3ff1b98009"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d75781a3ef72fbb1f54e6ddb6d2230ccdbe3268b469bfd9ddbc2c59bff2f11c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ac826a044086c94add4f6a0d57a4459b7393b68455f2f5a94d43bede27acee3c"
    sha256 cellar: :any_skip_relocation, catalina:      "b49d7b75281a8298841ab91368d30c8d3cb4ef9393d2835e42fb2b69664ba1fe"
    sha256 cellar: :any_skip_relocation, mojave:        "4f81843188073b2c33217f05151e45fd7c0f0d47fb3b96ca9174ea1e536956da"
  end

  depends_on "rust" => :build

  uses_from_macos "libiconv"

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
