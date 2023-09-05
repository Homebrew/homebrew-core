class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.20.0",
      revision: "56c9d09a1b925e2549631c6d180b0a1c2ebfac82"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cdea60885877f4f97fb6dcf13778977880f7fc52f576a04e2291498d8ce7045"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cdea60885877f4f97fb6dcf13778977880f7fc52f576a04e2291498d8ce7045"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cdea60885877f4f97fb6dcf13778977880f7fc52f576a04e2291498d8ce7045"
    sha256 cellar: :any_skip_relocation, ventura:        "5b14419848553fde2488870e0e9acaa02ccf4378b3a2bf4f1a188767b0be278c"
    sha256 cellar: :any_skip_relocation, monterey:       "5b14419848553fde2488870e0e9acaa02ccf4378b3a2bf4f1a188767b0be278c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b14419848553fde2488870e0e9acaa02ccf4378b3a2bf4f1a188767b0be278c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fe97b9007a06c1257c033fddb848c022c267f1dd5a1ba062b205d405df5a3cb"
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
