class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.23.0",
      revision: "3ec68fbf8c3a1b16ca0f69aeccfb93765685b643"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a436e68a13f9687ede9bccf7890011bd84a5ba4c391108e9afc76603eae7f146"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d2f14cc67a95e020d5ae4ee66cb9ee1bd93da308d9876f3182e8560a5bd05ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5406102e619e2771078b344307c2de70d632b0a9116dc0397e619347a5f55573"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cfc49ba41d8467c03d32ab6dd543dd84b0d0a766f5a6d0f03cbadc658891229"
    sha256 cellar: :any_skip_relocation, ventura:        "e1d39d25dc2415d9ac5531c16c842d1528da89ee65ef9cc2b5748e4103f69bdc"
    sha256 cellar: :any_skip_relocation, monterey:       "1462b54afc305ec098bdc28f581e704f858fce3dd79471eb36e2d9dd24902dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a9a9eacc7ed8a2241d4d612dae70a15bea670862d0b2f2fc9385688f201e07"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
