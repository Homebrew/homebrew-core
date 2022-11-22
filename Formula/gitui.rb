class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.22.1.tar.gz"
  sha256 "285e86c136ee7f410fdd52c5284ccf0d19011cc5f7709e5e10bb02f439a218ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e1d32b421c13e5c4dd48566fb3dda6b0792ebd7044d3c593ad79d6b752b242b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad9028f4ccd5bfffea1c6f7ef760f57ddcc15a3c78362f94dd6f73dc87be0e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1098bb7a2e673a521073735efb5afaf5557d24185b8d11623aa1a4b8a7f3522"
    sha256 cellar: :any_skip_relocation, ventura:        "16c2ed490a716aaa9401d3c008e5f992a770bb1b86bd41a4360845e795c127a5"
    sha256 cellar: :any_skip_relocation, monterey:       "fb033b80455d8b286b508e02b798dc961a5cd7693a97c13a3f957159479d9135"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d71c74d3cae9429b536d2311579df3d46fb3b4010b76c716f99d36da8b41d5b"
    sha256 cellar: :any_skip_relocation, catalina:       "ca69e974539086e097fc37650d18fc1e3f8676c39e5fa570c2bccae1f3d22479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b24c5b05ac59a33c54cf7fb310aae65a7dd92d9d707c01d2b6bd310b831cd2"
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
