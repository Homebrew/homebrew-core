class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.17.tar.gz"
  sha256 "4f81b6bc29046ad4a92a5ee9040f68a02debe93529abad78d806e4eaa35a17ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3add12bc0253132202b5c2ecb107599c480277d007c4373c0c0dd7a5fd49965b"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed47e892226cf153bab91657f145657419f7c1bdc290bd07b44cb957e1b451c4"
    sha256 cellar: :any_skip_relocation, catalina:      "000494aae7f19a34d9a363632a16951847468923101e15b3644a307ddff96948"
    sha256 cellar: :any_skip_relocation, mojave:        "f5e9eebf059917dd42e71f34a14c6654baa9b7b91518f7324a966060040318b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e6292c7b708ee63e9da1a99f17166a9fb48d28a22b6f6b4d77dae9f016ab70"
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
