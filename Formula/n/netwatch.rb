class Netwatch < Formula
  desc "Cross-platform realtime network diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.8.tar.gz"
  sha256 "461542c1c8ad88c0552982dac71751aedf732f7946eb9f2ee63e72374b8f886c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f61f9d619ce556e8c2bfaf356527132ff5f2c92bb18b3526e5d7d38ad4a4c88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6063620c4ed56fdc0a3c4be6781ce38780a2d1388654754920e66ccf3958050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cb7c752958680a074e7bf85647ef70ebb221405bd83dfde25ddfef4f45e9d28"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ff348d4d9dccb3ebedd5efc233a0d47ef11b08a0f140d3cdbdac923cd5b2a3"
    sha256 cellar: :any,                 arm64_linux:   "db58e2b37e930e3636a1c2eef4a0a63ea80af44e70e269e9a54ccf8592be65d3"
    sha256 cellar: :any,                 x86_64_linux:  "94cee99d3192161566bd4b07cec87b315518535bf81ab02f87a26b76a7265acf"
  end

  depends_on "rust" => :build

  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Open3.popen2("script", "-q", "screenlog.ansi") do |input, _, wait_thr|
      input.puts "stty rows 80 cols 130"
      input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/netwatch"
      sleep 1
      # bring up help dialog
      input.puts "?"
      sleep 1
      input.close
    ensure
      Process.kill("TERM", wait_thr.pid)
    end

    screenlog = (testpath/"screenlog.ansi").read
    assert_match "Topology", screenlog
    # match text in help dialog
    assert_match "DASHBOARD", screenlog
  end
end
