class GitFlowNext < Formula
  desc "Modern implementation of the Git-flow branching model"
  homepage "https://git-flow.sh/"
  url "https://github.com/gittower/git-flow-next/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a122ddd1e772fb57271b760400e334f5820d7dcbf9f3f6e080e976e4b978cbeb"
  license "BSD-2-Clause"
  head "https://github.com/gittower/git-flow-next.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57fecbdf2e6e180659899da60ed55c4a44e79e6ccab58baae0c9364d95dc62e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57fecbdf2e6e180659899da60ed55c4a44e79e6ccab58baae0c9364d95dc62e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57fecbdf2e6e180659899da60ed55c4a44e79e6ccab58baae0c9364d95dc62e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "57fecbdf2e6e180659899da60ed55c4a44e79e6ccab58baae0c9364d95dc62e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b5ce631a8784e5b108b6a61ccde07883af075f7a6668c8c8c07948cfc3c1d63"
    sha256 cellar: :any,                 x86_64_linux:      "ad4a97c0e6b6d84f3a2cca26f4bb1a4da78a9afdcc00c4e9d879c1c8b12d1f41"
  end

  depends_on "go" => :build

  conflicts_with "git-flow", because: "both install the same binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    commit = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -X github.com/gittower/git-flow-next/version.BuildTime=#{time.iso8601}
      -X github.com/gittower/git-flow-next/version.GitCommit=#{commit}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-flow")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "flow", "init", "--defaults"
    system "git", "flow", "config"
    assert_equal "develop", shell_output("git symbolic-ref --short HEAD").chomp
    assert_match version.to_s, shell_output("#{bin}/git-flow version")
  end
end
