class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.11.0.tar.gz"
  sha256 "ba32583bb6afc3adac8fe78d8ce10fd127b2fe4f62bc24b301d1ffbfb838bf98"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "60db2601c6791f28adfa590269af2216b644c0aec57c7b76760fdbd2782c9b4c" => :big_sur
    sha256 "90607a35df37269e87bf2f023a53d6fb70fda7902320b957cca080b286e2f058" => :arm64_big_sur
    sha256 "58b881c6404ef201a9f386285cad4be06eed6f9da934895d9feb6e813cd9448d" => :catalina
    sha256 "724c0c2e5055cea5d49c376c2b6c8681847cf9f0a45079a3fff103f2e5641028" => :mojave
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
    screenlog.gsub! /\e\[([;\d]+)?m/, ""
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
