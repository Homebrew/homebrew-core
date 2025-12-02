class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "89e77bec5c0519835e1561ff9def0168cc72b8736b1a38c97892b1511c755e66"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bd87d9decc1c64dff6955a9778f1830414004ece0688a3a24f49aeed5d439ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd87d9decc1c64dff6955a9778f1830414004ece0688a3a24f49aeed5d439ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bd87d9decc1c64dff6955a9778f1830414004ece0688a3a24f49aeed5d439ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "be59b2edc7fb80d972227f1a05a63f3ac063f954a899af51a9c1f5f8fb3c4f12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70fddb8fefd4288c0b24ab2a72832b6811925604bf0011b2577598c98b3f407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc440768d18a83be53b79736e57a2e54c130ace91fb87240f9e9dde14bf31633"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "failed to fetch 'listblockedips'", shell_output("#{bin}/nak relay listblockedips 2>&1")
  end
end
