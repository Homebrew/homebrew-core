class OhMyReddit < Formula
  desc "Beautiful Reddit threads, live in your terminal"
  homepage "https://github.com/renatoworks/oh-my-reddit"
  url "https://github.com/renatoworks/oh-my-reddit/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "623db2b5489557f9b44cff6038b83ffecd8b35fdbd83766a78b52327a7f46ce6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d84be470ad928d3440bfc4c27821328e6bdda8828de6b5b4eb649a26bbaf3ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "515d42c879fd0c0596fb8e456e7f757bfdcfb6fd834d0cc483a7fca22d1d2b21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce393fc27f603b8a3bab6df418e5f87f7e3217fb2625264daa70c978bc541f08"
    sha256 cellar: :any_skip_relocation, sonoma:        "9af1d06c5ef0e69dd9fbe42b5a395e587c0bd10a8746ac127bec88983233862f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48ce6c0d9e9338fba5ddc2a297603dfcc9f5da0833aa780a3018b184c759fdb9"
    sha256 cellar: :any,                 x86_64_linux:  "0e358e168121424957b6f6afea1c72ba038d2c729fa2d3ee73e992051ed1823d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/oh-my-reddit demo"
      sleep 2
      input.close
      sleep 5
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").binread
    assert_match "t post", screenlog
  end
end
