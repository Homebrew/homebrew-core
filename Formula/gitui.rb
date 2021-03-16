class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.13.0.tar.gz"
  sha256 "ebf3ba559d05205e629805f60441411a0609e2a84444753cfd3a4a3ff1b98009"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7fdf0001ba47e7cc8188775f085b5424f61e5b765504659901b6f3f86d0ef20e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c52f24f5083157fd9b11fac97770c54ca7f33e342395f333786fd8392a0f562a"
    sha256 cellar: :any_skip_relocation, catalina:      "10c4d71d207d24f5f4ca17af16ed078cd6c94d4f5c3fb350d0a0199c5c146324"
    sha256 cellar: :any_skip_relocation, mojave:        "3fcb263410e6a6726638bc1eea8f9f7e1b650509f65cdf4fc2c65735065e8099"
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
