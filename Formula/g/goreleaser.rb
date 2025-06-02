class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.9.0",
      revision: "68b1443b2d43cfa574788af8c1ab1b29980558bf"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b6e41c0197b6c80a70e748bcbbb92b3a851f7ba39edbd480d0b858d5bf6390e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b6e41c0197b6c80a70e748bcbbb92b3a851f7ba39edbd480d0b858d5bf6390e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b6e41c0197b6c80a70e748bcbbb92b3a851f7ba39edbd480d0b858d5bf6390e"
    sha256 cellar: :any_skip_relocation, sonoma:        "864e3e04c010b6ffc47d927905b0e59225213c7727450fab5404e616b779f69c"
    sha256 cellar: :any_skip_relocation, ventura:       "864e3e04c010b6ffc47d927905b0e59225213c7727450fab5404e616b779f69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0efa78b8384595b572b0ce78d8f2a429a7de67f4cb199774f546f2cb39b7d9"
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
