class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync#readme"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "ff3cdbfa3116f8d1369bf53aa17dbf93c1c83be9fed315f7cd393e756c2d3d96"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd61e6637363b675cc688c62c13184ae6088341bba33aaa6caacbb2b3fc9dab9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af7aed521da7ab1712a9b2ad5881fc6dad900132543327c2eb377da2b6489d5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb820a35218d92b6a65bad71e7b4e0548d77bc7ca4b334c94bdaa736a4d315b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ca7b42dcbf5cb2beb9a156fd54b1b7fa43690184dc90837e4d96492ce056762"
    sha256 cellar: :any_skip_relocation, ventura:        "9ec20625f11c10e80fc46ad4b6f80d25dc0f6e027dc2214008a13b84c66ae1b6"
    sha256 cellar: :any_skip_relocation, monterey:       "0f0dda80f65c2cc35171682e0985b7d5b77f08cdffe16385496c83664360ea2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "058cb7616e743dabe0e32b64877fe5959fb1f42bbaedb4daaa83b66f670b6bb0"
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
