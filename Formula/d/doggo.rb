class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "1965f4c909991bc38b65784ccbc03f4760214bca34f1bb984999f1fc8714ff96"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b788c7ba4ed0cf74463335b2f013e1a9846fc2ff1df0e73a889447625839917"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a28947b7d156241ad42c3525cbaf52f811fb1c956b255430c5248b5997ea5aea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21883ad0571cdd465fa838154dd32a1f18650ba04512a502ec4e58400242c63a"
    sha256 cellar: :any_skip_relocation, ventura:        "4c95b7e5d1eaa1827f94634df29794f7972fe3ca881072116ffab8926062f666"
    sha256 cellar: :any_skip_relocation, monterey:       "0e98ea20aa5596ec69607bfa22a0d7aa891ef398d9162fcfe423bcb4192f8f87"
    sha256 cellar: :any_skip_relocation, big_sur:        "a102dc47b0ff374bb0449f973710af220d4fca7e313ab5f8b0372e7ea3299731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52e0cbe5449476605483e106b02c23e93daefffd4879410d1cabea145fec7efc"
  end

  depends_on "go" => :build

  # quic-go patch for go1.21.0 build
  patch do
    url "https://github.com/mr-karan/doggo/commit/b296706c7b25a9bfa40fd927af9280b836c03c3a.patch?full_index=1"
    sha256 "27f3444ec7e3629665dad7a767990cb118807575894bd7dfd13ce481a937eaa9"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.buildVersion=#{version}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doggo"

    zsh_completion.install "completions/doggo.zsh" => "_doggo"
    fish_completion.install "completions/doggo.fish"
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
