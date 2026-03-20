class GitFlowNext < Formula
  desc "Modern implementation of the Git-flow branching model"
  homepage "https://git-flow.sh/"
  url "https://github.com/gittower/git-flow-next/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2efe4fc1416ebf7018ae46954df67992afd187dd51d954e55a61b7bbf716bc23"
  license "BSD-2-Clause"
  head "https://github.com/gittower/git-flow-next.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf81aa88a5048c61d1d9ed6c5733add8627e46e5257845879cd5fcceb9a0bda9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf81aa88a5048c61d1d9ed6c5733add8627e46e5257845879cd5fcceb9a0bda9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf81aa88a5048c61d1d9ed6c5733add8627e46e5257845879cd5fcceb9a0bda9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea63faf36d3bc65ab13bc19d2e66d47471baf0deb305ba798bdb4007e61b99cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb3434f3fce699867ac2a329a93b17be5d973280f39a15b8ee905589d054436a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5adef590191f9ebf323be7c32ed8a8b12142a716e404a5f77fa46083a037c763"
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
