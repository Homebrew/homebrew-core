class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.22.0.tar.gz"
  sha256 "5881ecf9cef587ab42f14847b7ce2829d21259807ffcdb9dd856c3df44d660a7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94ec4ffddc9ff28779be048ceeacec1f126d7f9a9bb5d9f03c00ad755dd57853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d9e243bd1aca529db25c40bffe2b5da5aa6c3be6427d4d614babd7e48915ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a306856b92c55080ec447be66c6a03e36428154d0e7b63922d60ba6c3f8624c"
    sha256 cellar: :any_skip_relocation, ventura:        "e3357e03bff5fe044e648e785073ca1ecd8f836c68df0f6d0df63becb612acb9"
    sha256 cellar: :any_skip_relocation, monterey:       "66c45e185fc3c3494b1c965bd4373a2ea34996b26fc8e839548eccca81f18271"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebe75d0d97989cd3f3ae83cda32cc545bed4f2f9f798dff2039737e4e3ec6cdb"
    sha256 cellar: :any_skip_relocation, catalina:       "d0641624fb4122d90fdac164f0813ad83667c8db06759d9bc814d16ea2519c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c592a405dcef3c5325063972bbac70b6fd599e02f9f5191a71ddb90e2e84d25a"
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
