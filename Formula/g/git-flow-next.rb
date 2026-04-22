class GitFlowNext < Formula
  desc "Modern implementation of the Git-flow branching model"
  homepage "https://git-flow.sh/"
  url "https://github.com/gittower/git-flow-next/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "cb91dcf6b5901d9c65800a971fbacb556a9a90971d5b4883b968770e2383130f"
  license "BSD-2-Clause"
  head "https://github.com/gittower/git-flow-next.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14c7ba0d3cd9aceeb6f7f27c116290e4a8344114645b4e0ff042fdde202687ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14c7ba0d3cd9aceeb6f7f27c116290e4a8344114645b4e0ff042fdde202687ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14c7ba0d3cd9aceeb6f7f27c116290e4a8344114645b4e0ff042fdde202687ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd4f295c2ba07487bdd4ee938bb0cf63e97a70b90ece4f4f3cbafe265c5952f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96515070a214836708d8a45e589d2fc8ce129f24c0bfe88064b5793bc487628b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46758e4929c4cd2b9c6bfbd366acd5bca141d938b797439f053427f9b55299df"
  end

  depends_on "go" => :build

  conflicts_with "git-flow", because: "both install the same binaries"

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -s -w
      -X github.com/gittower/git-flow-next/version.BuildTime=#{time.iso8601}
      -X github.com/gittower/git-flow-next/version.GitCommit=#{commit}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-flow")
  end

  test do
    system "git", "init"
    system "git", "flow", "init", "--defaults"
    system "git", "flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
    assert_match version.to_s, shell_output("#{bin}/git-flow version")
  end
end
