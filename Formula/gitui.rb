class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.16.0.tar.gz"
  sha256 "181ee579613daf5f7cde39d29c464a14332614c25951765b16ad65fdc6e00188"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "922b02ea87791bf93ef8bda43f1d486eae11ea7d09cc38172d850b4c2689a39b"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae28951e0b9eb23f44bdf4f4b928c8f3b2516ce852ec92b01fb012240d64c984"
    sha256 cellar: :any_skip_relocation, catalina:      "98e8623f0f2c16a89baf87873706b871b9d1537c1b9548441aca11037b2ddfa6"
    sha256 cellar: :any_skip_relocation, mojave:        "a3b4548d4cf4ce96d5e6830a5cfc3a30f530107fa0c2093f0cd125c9e8341d69"
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
