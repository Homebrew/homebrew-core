class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.6.0",
      revision: "cf9e160f4e12b0f421cd7947e2988bec963498dd"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6efa0f09af5f5ca4de95cb1908e96b434526270f1a6e8b20a278aeffd31a60f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6efa0f09af5f5ca4de95cb1908e96b434526270f1a6e8b20a278aeffd31a60f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6efa0f09af5f5ca4de95cb1908e96b434526270f1a6e8b20a278aeffd31a60f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ee1d3d26b3f5f3b5adc9cd2c89e3468c367b767e54014461f69623adf63ea3c"
    sha256 cellar: :any_skip_relocation, ventura:       "9ee1d3d26b3f5f3b5adc9cd2c89e3468c367b767e54014461f69623adf63ea3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "792affd0a386517c46f4deecbf4f690280b22b86fcdfbcd89c6455f781f608a5"
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
