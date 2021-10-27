class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.18.0.tar.gz"
  sha256 "7c8d5829fc8e555d02c576ba0325f0a68114c1fd2eadf17166a3bda866f539be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "273ee58b44cdb151269d9a171395ed41ae44660ebb39cf3241978d3dd62712ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eab0d0bf479bde503eeca2ccc61125906255e81c817fb8b74d26777feb594f5b"
    sha256 cellar: :any_skip_relocation, monterey:       "37c62dfd2402f0d39d768ffa345f122f72b26aa421b1e92a274d7fe3bf558c3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfb00782b725ea3365100d4be6bc8c4756e4a183e3ac73cccdcd982b5d1c4c98"
    sha256 cellar: :any_skip_relocation, catalina:       "032d6a437bf658b0ec9dcacd6877e830e99a6a353fce0a611b818e65cf64b0a3"
    sha256 cellar: :any_skip_relocation, mojave:         "36e93f2d9dfee08d1c2a52cc350b14b214719730396bcc8da951eb1786c9561e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4416575824156efdfa9ac272b5b5999b94a5fb3b4e3ae431c2d2c45c2303e770"
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
