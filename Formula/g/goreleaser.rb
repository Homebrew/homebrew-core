class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.12.3",
      revision: "a1d945da6150425f5e7188dea819992d8a600b8e"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5477df0850c9385ffdfc240bf23cffc9f10b11cabd6ac324f5858b594f1ce87d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5477df0850c9385ffdfc240bf23cffc9f10b11cabd6ac324f5858b594f1ce87d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5477df0850c9385ffdfc240bf23cffc9f10b11cabd6ac324f5858b594f1ce87d"
    sha256 cellar: :any_skip_relocation, sonoma:        "419c534dacc9ff7e34114d05f4bc0905c9357b222f31303b928532c5ec44e243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef33c420aa960c3d2676418be0783303789efa0c63c480f9f05f99f5366b0134"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
