class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.15.1",
      revision: "7c6bd86b286ee76cfb0a0b4ec17d18d4ee9daeec"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d64e94b964b26969b9d94e8939251ff17af15224b6d341cf507caee80cf57c19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7413d56c779aa9f8efcaeed280b90ac8000e0b3dbe7d93efb603a6611323f936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00ba66e11f1365d3cb23dee06bcf3f42422de3982faa50d98a15ee5b1749a830"
    sha256 cellar: :any_skip_relocation, ventura:        "08863c60328f1b73d761cd5ea77a5cd9258751c3531f55cbefdb7a549e67a468"
    sha256 cellar: :any_skip_relocation, monterey:       "135e3b5b8c8ec324a78aaf4161a84930af20c705c692954b2025f4416a8dbf2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3ae396df05dcd6af13d0f72a5cc15934788049762662c4490fa7e34c93a81b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38c77f4d9c872616b122246a048d2209d278c61aab260e87f8a416842949a795"
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
