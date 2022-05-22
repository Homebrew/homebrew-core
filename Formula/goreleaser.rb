class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.9.0",
      revision: "a52fb997d1b31a08cecd09e69c797dd99df56207"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d302536344c16e94f938308398512d1136e6fa7f42ed23b12dcb70f3874d2c9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78bc78a886c7e4ba0535ca7a14b3af5264dd324ad7292b4bc0da2336dbbb2726"
    sha256 cellar: :any_skip_relocation, monterey:       "080db171e6a863a1a679ca20ed66da388e7f8aab73198a3565b893cb33866317"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb93847eaaabf35acf5fc6d4a29819fad1192d7a714fd28d3523e4a4a551aee1"
    sha256 cellar: :any_skip_relocation, catalina:       "d9c1a3c655623e7872c2e022040fe586f6de7bbb6ad8f8d9223b84a6eac5d0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93d6461e304ba76b7e0c31807c706c6f171bf664922ff15c52a9e1c69f06b683"
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
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
