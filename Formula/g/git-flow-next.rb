class GitFlowNext < Formula
  desc "Modern implementation of the Git-flow branching model"
  homepage "https://git-flow.sh/"
  url "https://github.com/gittower/git-flow-next/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "4f6078d5e3fb0b95d48dfb0327cbe48f04a96a9556eb5eb1e1d6b6879281af9b"
  license "BSD-2-Clause"
  head "https://github.com/gittower/git-flow-next.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8ef07136499869e66c0d3a607e0282f032503a41a306d5017d3331f1538951b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8ef07136499869e66c0d3a607e0282f032503a41a306d5017d3331f1538951b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ef07136499869e66c0d3a607e0282f032503a41a306d5017d3331f1538951b"
    sha256 cellar: :any_skip_relocation, sonoma:        "211a3d4e9cfae3ac984263b39caa69bd91acf9cda9ad875b3fa5926b3a301f90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b969d80b8a506129b2c846474352331b6d7a2dd9ff6c24f75a1cde9f3d1fad7f"
    sha256 cellar: :any,                 x86_64_linux:  "77258f25d7bdb1844a47944b239c47eb7fda93092f25d2c2226de9711e6d08fb"
  end

  depends_on "go" => :build

  conflicts_with "git-flow", because: "both install the same binaries"

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
