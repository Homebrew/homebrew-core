class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.5.1",
      revision: "a167e697a0334766bd4085b38508406ab9528b1b"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11fb1f9bf91cdc8a8c63579459eb51a6d38dc49f652c74f0bd36e5dd72e8f737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11fb1f9bf91cdc8a8c63579459eb51a6d38dc49f652c74f0bd36e5dd72e8f737"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11fb1f9bf91cdc8a8c63579459eb51a6d38dc49f652c74f0bd36e5dd72e8f737"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f8a8377b3b8196f76e18ba2f17919cab7fc19229c4576716538c13fa73eaf78"
    sha256 cellar: :any_skip_relocation, ventura:       "9f8a8377b3b8196f76e18ba2f17919cab7fc19229c4576716538c13fa73eaf78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59c4491fe23fb0fae7fdcc5463da1bb0a0b05c0d5671399c5ca7fe5f9c5bd912"
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
