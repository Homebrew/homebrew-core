class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/sjlleo/nexttrace"
  url "https://github.com/sjlleo/nexttrace/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "58ead840cca5c067f6a5436265025c82604866b124d2462871d56abd0328d4db"
  license "GPL-3.0-only"
  head "https://github.com/sjlleo/nexttrace.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3e42f9e333063173e506fe8187f603bf4e21839b2300fe47efb5d6e3524c9e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3e42f9e333063173e506fe8187f603bf4e21839b2300fe47efb5d6e3524c9e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3e42f9e333063173e506fe8187f603bf4e21839b2300fe47efb5d6e3524c9e5"
    sha256 cellar: :any_skip_relocation, ventura:        "077d2910cbfef29607e4385d7d2fe8f321a965fb7953003b36491b376f99af9a"
    sha256 cellar: :any_skip_relocation, monterey:       "077d2910cbfef29607e4385d7d2fe8f321a965fb7953003b36491b376f99af9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "077d2910cbfef29607e4385d7d2fe8f321a965fb7953003b36491b376f99af9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24dbfb0a31dd4bbff50d261d88d77b54a3350fbf176e6adf50ff4b540dc82ded"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/xgadget-lab/nexttrace/printer.version=#{version}
      -X github.com/xgadget-lab/nexttrace/printer.commitID=brew
      -X github.com/xgadget-lab/nexttrace/printer.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` to start
    output = shell_output(bin/"nexttrace --language en 1.1.1.1 2>&1", 1)
    assert_match "traceroute to 1.1.1.1", output

    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
