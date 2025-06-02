class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.4.1.tar.gz"
  sha256 "823574c624d95dddc931fd6853ef123d460578aec85bb6c0deaa60aa096d268d"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72b49a898c83aef448141b406ae6e6dad7cb60bd136908cf0af81fccee8e19af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72b49a898c83aef448141b406ae6e6dad7cb60bd136908cf0af81fccee8e19af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72b49a898c83aef448141b406ae6e6dad7cb60bd136908cf0af81fccee8e19af"
    sha256 cellar: :any_skip_relocation, sonoma:        "a41d75a5cd5c100074f06b743406fb49f8a4d4685e3ed2fc06e0de58e257c8be"
    sha256 cellar: :any_skip_relocation, ventura:       "a41d75a5cd5c100074f06b743406fb49f8a4d4685e3ed2fc06e0de58e257c8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a51a30d49f6db8d0b5bbdd8e8678188e9fa5765b54d35770db3d31d79a873c0"
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
