class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.6.1",
      revision: "b6bb03ddc28d6de71a37012107cda26af53cc116"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e220ebb96ab30da01105ffffee33b137205c6275861d3e31baf8adf3ca35dfdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e220ebb96ab30da01105ffffee33b137205c6275861d3e31baf8adf3ca35dfdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e220ebb96ab30da01105ffffee33b137205c6275861d3e31baf8adf3ca35dfdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "efb6c1cdc92ff036a48edbdc1b0230745c6530363df9dc4cd10511723c498b58"
    sha256 cellar: :any_skip_relocation, ventura:       "efb6c1cdc92ff036a48edbdc1b0230745c6530363df9dc4cd10511723c498b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aa549e92ac3a292f4d35e7437d2685b22786e162b77cc665b69291700b7f38f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
