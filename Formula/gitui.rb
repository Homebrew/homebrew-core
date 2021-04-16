class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.14.0.tar.gz"
  sha256 "4312e6028c314bde12c7515a76aaa1fae518c8cefa6ab2e3a1a70c680e7dcb6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a9c046cfc75c14a01088c3a5978d80ecc0500d18e63d511ced2680559a031b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1009173a51d1b06ea0da093bb43ca58ddcb4781c37a0892b2de1f992a28e484"
    sha256 cellar: :any_skip_relocation, catalina:      "3933c0b7cf1ceb90d3b6520ad3dfe3e2f46fef021db6f061efd0f29393765978"
    sha256 cellar: :any_skip_relocation, mojave:        "d8c7c18e659287691eff8ecdd2a636ef6dd8cb0ceee6cffcbffa4f8e9a1ad113"
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
