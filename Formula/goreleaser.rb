class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.2.2",
      revision: "114c98072645591a4cadeebab62920b5ce7ad95c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "750639101bfab1a49fac1fc9bdeb6a61bcbaa6bee88252358fcd98b237179e88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "728a3b51ab52eb1ac80a9ad04a3a05c5233aa8ae9f0178750a06969dedf4b9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "185acf98a9ac2dda029cb33ebb109d2216fa6d4bc774631b6219ddd161f9cffd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e36fd83eed67d9e10242905f98e43ee30b926e08ac6f0d85da1785f70ba79023"
    sha256 cellar: :any_skip_relocation, catalina:       "4a310883f308dd4bdb2e11b2a3f4c1f2278152e1790c252c1e2131c6dd8c8ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc21a26184efeafd26e613406b27891ca770e10509ecff2d7a32d52b3606286"
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
