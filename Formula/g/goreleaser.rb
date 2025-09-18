class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.12.2",
      revision: "d3d28a6aa7c7fbd070013870670dba88b13e8eb8"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1129bb231b6494226692e59676410b628e4100a31edb94a6cd5dd46ea3f629be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1129bb231b6494226692e59676410b628e4100a31edb94a6cd5dd46ea3f629be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1129bb231b6494226692e59676410b628e4100a31edb94a6cd5dd46ea3f629be"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c3f977e6acd9883beb0ad2946e6aeb2e0043e7af6d83880720cac7fa431be80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "830d9ce3086fe787be5c4cd6f3cb4a896427e9b6f921533f76ac07f6c734fe82"
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
