class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https://nextdns.io"
  url "https://github.com/nextdns/nextdns/archive/refs/tags/v1.47.2.tar.gz"
  sha256 "d4a57f07f51a58ab57f8ff872678fc81be76c3985011ef0960b156df361ea44a"
  license "MIT"
  head "https://github.com/nextdns/nextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9067118923db2bbc4f2c6baa1ea08000edfaf40b5a0c21454447399548692573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b450a22a7194c214ff848aeb912cc709c91f12667e7f9c012c92fe91c0f7fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3573e6395f91968574ea4da04309ab318e666eef01219cc11151949e824d13a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c82954d9507e2e1d207aeaed0b0a9ad91263976e72cae770add75d157de5a844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f186bcf1752c104ca78daea2a08553b7ab51a4f32a3d518daa13af6045906e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c873eb0bcd6b577353898d499c1eab28e520483d1445e5a8ca351034b0e3a73c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output("#{bin}/nextdns start 2>&1", 1)
  end
end
