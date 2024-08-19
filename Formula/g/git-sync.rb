class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.2.4.tar.gz"
  sha256 "866b7460984d0badc4ed150bdba64abdfc9e5a51fa0680884da2d22f328db8dc"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a615a47006be2b012ed1c6422dd1c3baf368f4116295c9fa98df360dae01a057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ce5d9a6df47820cfb3df008180d243019967095689fca4b0be99be661f24f04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c78f89766f54d096d0942712890910f818541fb6ac9bfbaf583684a7fa6fb45"
    sha256 cellar: :any_skip_relocation, sonoma:         "973bbb32f928b73d35ddb92d31f4443e750293d342b40e94e0b57f8aa087b1ea"
    sha256 cellar: :any_skip_relocation, ventura:        "9b37fcc62cefd1f0d78c37399aca63b9ae4735de69f40a8003653dbb5d84061a"
    sha256 cellar: :any_skip_relocation, monterey:       "36bec0ce10c5b628e411b0bff7adb3db580113638d92aff5145725198a91cdca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b500902f7fa35c2cdf91550f767f312b15da34baa428966f1567acaff45258"
  end

  depends_on "go" => :build

  depends_on "coreutils"

  conflicts_with "git-extras", because: "both install `git-sync` binaries"

  def install
    ldflags = %W[
      -s -w
      -X k8s.io/git-sync/pkg/version.VERSION=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    expected_output = "Could not read from remote repository"
    assert_match expected_output, shell_output("#{bin}/#{name} --repo=127.0.0.1/x --root=/tmp/x 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/#{name} --version")
  end
end
