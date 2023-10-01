class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.21.1",
      revision: "b552487f6ab59d1ffe859c5ad7f5fb78532fb0ae"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a52bf7c58dd1f14e4d5b70f40a1b52ece59644a0e27a84d5ec80df63663df55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c30f063dbc1f97219bcfa9ea9061cb6fd708b93dd4e46347f73d7052d152521"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a16cee9409544901c744e9f6bad34b364feaa00a3d1d19bbc165df0098a5d752"
    sha256 cellar: :any_skip_relocation, sonoma:         "52424ebc23c6bbc33f49d727e4a5c1bea9abeb1cd47fd4f10ac54be1f24674c9"
    sha256 cellar: :any_skip_relocation, ventura:        "c71a7b100ab216cc777c50e7b8ffd5893d2e1ec9dbaac4e3467ee98239573c73"
    sha256 cellar: :any_skip_relocation, monterey:       "ab01308c5166ca4f984511d26c29c844bb9d0f4b4b52522a4086046319f46993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6fc99393530a7ed9e5e8efc7992c1e5b62fa336d5aff7bc2af57ce200d2c37"
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
