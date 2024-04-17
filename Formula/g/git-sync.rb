class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "e47fdb2173aaa20f9a89aea2be21e77a2d36f8c8e0c499c52b51e025ed734d37"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08b7f2726ec0c3935598dd5169d7c4a67aa5b9532de36ce7349c362be87db065"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e4ef5a590b8acf6d693d685f33657fd204875a73ac60637bce9519845bfc922"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06ab66b67f09fb27fd50484bbb87eb3ab424bf87bf56a001eaee5068dc60f074"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdc14af2b1019d96aa2180ccd87fff4cfe0b98d48c9d9777b51fe38b4b8b0a55"
    sha256 cellar: :any_skip_relocation, ventura:        "7312740153a56d8311bdf5cddde22245738f9a051d7c33b40518f3516cbfc1e9"
    sha256 cellar: :any_skip_relocation, monterey:       "15e35c17979fbd0cb5c22c107216b7801b5dcede2e7ce51e4599ab954f93b9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ee5338ac08681952fa64a91177594007fa81619951a1ebb6ff01b89556a2fa7"
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
