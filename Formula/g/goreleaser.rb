class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.2.0",
      revision: "111121bbd98df17cc5d81888aa94a8d3694bc157"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f1e4582d18e6e5efde00e3c03f2c64e6b4d2d19324a7e1d596e57b83f9831fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db5262eff095b6f39842db7842db4efcd17b2740c79960934749817be10a0049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23a991c1283bf553a578beba7ab8468de2fffa6d1ef2543a8cf684001338edc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "49e389be1459591069d68ebc36bd1ff980eaf651ef9e0466c85c6111b56a43db"
    sha256 cellar: :any_skip_relocation, ventura:        "9f6349e22ca63e99b26bde03e7d0ed9fe7b8611155ffbfdd9906cea95051dee8"
    sha256 cellar: :any_skip_relocation, monterey:       "6ecf6f4a2face05e39ddab41598b014c0511169721c1bdb0ec868d688d2f8172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acf721d9370c5772708e044a347e862e6a45d115e0255f67b933efdad5d08bf"
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
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
