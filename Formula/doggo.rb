class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "81815c4b1230109d2ec5767dccb4a486468b214d3f3fa9ac7ed41463e01260cf"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "046a13968d24a5a43fee494ab987c7568a3111905f807f2448aef4d1a0fc2b90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55a818010580cc97f183bd42a6279553733f6672de2dceb27ec56643ec0fd5a4"
    sha256 cellar: :any_skip_relocation, monterey:       "07183902cc7b73f0a09a7d2ab6f11369d261d39805bc11577c026fcba44c64ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f9d8e9ff1e45734211f8ebe02eebeb1c9daafaaa96f380f9fd9513d02e6445b"
    sha256 cellar: :any_skip_relocation, catalina:       "764f07add2600a4c6df47f41aee089b444e03e18e2a4777a6a5969d0b9878572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08a993241db6f80d4ac98d617c4987962a6595c6dedcc0981798e85c14aab9a1"
  end

  depends_on "go" => :build

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
