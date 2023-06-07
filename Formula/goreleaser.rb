class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.18.2",
      revision: "ad000694196f30e2cdfe561fd20b20bb85c5258b"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4b19bd907620527647dad10a7abaeb1b08916fff6de9ce40c4e917eab7d7b8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4b19bd907620527647dad10a7abaeb1b08916fff6de9ce40c4e917eab7d7b8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4b19bd907620527647dad10a7abaeb1b08916fff6de9ce40c4e917eab7d7b8b"
    sha256 cellar: :any_skip_relocation, ventura:        "286dca82fa5d1358b2002df02585acd2c07ba8232573c10ca2919025efa7f955"
    sha256 cellar: :any_skip_relocation, monterey:       "286dca82fa5d1358b2002df02585acd2c07ba8232573c10ca2919025efa7f955"
    sha256 cellar: :any_skip_relocation, big_sur:        "286dca82fa5d1358b2002df02585acd2c07ba8232573c10ca2919025efa7f955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c56f7f3492732b721cbfed2f707b83e366efd68eee8af26ac138dcb55b289865"
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
