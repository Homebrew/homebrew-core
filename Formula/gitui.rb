class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.17.1.tar.gz"
  sha256 "36821f83d67a1233e10daa51178c03250618964ca5a5b8c001ac338bf7a355f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f201f17af26e1990454f176b25f599fff9adc0adc30e65a62034a8d7c4bed5e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ccd6212f22ec547e78f1bb75fb80e08d0338c84d9fedad25c14db978e9be8c8"
    sha256 cellar: :any_skip_relocation, catalina:      "6a0bd3473c9c9ecfa3f71e293848c7a44f1b73f0413611f09e23bc0c9448ea4c"
    sha256 cellar: :any_skip_relocation, mojave:        "636225978fedcb995d9bccd852ffdcedfd634b91c1bbd73029c0a40d562d64e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c2c3ebe90f869b73df7b7e082d4b4c4625f473b9243dcc49f3824a447791c1e"
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
