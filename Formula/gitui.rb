class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.17.tar.gz"
  sha256 "4f81b6bc29046ad4a92a5ee9040f68a02debe93529abad78d806e4eaa35a17ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03ce763a0fd2a582b0386ce335308aa06fc50703e84f41b8227b490137bc66a6"
    sha256 cellar: :any_skip_relocation, big_sur:       "c36d1d5315900e6a8712d0f2726c8084dd7b6d88c67965677f3c7d6c601fe4d1"
    sha256 cellar: :any_skip_relocation, catalina:      "cb14516ce1beb0fd67f0554cbe4daa75c0ff5260c648b9c4c229a066b8533bc3"
    sha256 cellar: :any_skip_relocation, mojave:        "40a858eaeee6fc6108d577a63ebc58a64eedd738bb7330fc536a750c8f6dab09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df440c4b1e5f6bb702be27107dea1504b247a890bc9cc97765f5b432341c26d7"
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
