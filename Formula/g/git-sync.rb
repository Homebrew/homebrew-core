class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "4fa8fe2b13bab19e120018378c38992d6ded577e93ec8c82a3a288fc707d8bac"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd1f73e1be67ef72df4b8364cb4fbc0fda30b3f52d501fc98f18479756c4ddfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99eff64024d4ae0c795669761687558436d19941b05686cef2cd12059bc1d11d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b54908f6c7b30465ef2c131447311d4154284efbe91d51323e3ffc738e8d0ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "86b77b65033d43409dd4d4072079c5dc211de776ddd4c2b81c0d57d23e26ad6d"
    sha256 cellar: :any_skip_relocation, ventura:        "d52be99b1d88243ebe44e0911b600c113f24bd11a62add6c1ee3363bde71f65b"
    sha256 cellar: :any_skip_relocation, monterey:       "d80f2474681f13bb03a7f3e2e88be09b770dc4ff778408c3ba768ad0ab73853e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7297ef07ab357851eccf14b27da316653018c58bd6e4fb5d1c68f10312f8300"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end
