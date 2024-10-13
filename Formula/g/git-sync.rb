class GitSync < Formula
  desc "Clones a git repository and keeps it synchronized with the upstream"
  homepage "https://github.com/kubernetes/git-sync"
  url "https://github.com/kubernetes/git-sync/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "54129054aac1b8766c320b69063af29e3a2c8c3a3e6d635312fdae93cbefc25c"
  license "Apache-2.0"
  head "https://github.com/kubernetes/git-sync.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c18764c9d5ee98380f34885fa2aa03f4200ba6e0255deb6c5f6ca906fe3f660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c18764c9d5ee98380f34885fa2aa03f4200ba6e0255deb6c5f6ca906fe3f660"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c18764c9d5ee98380f34885fa2aa03f4200ba6e0255deb6c5f6ca906fe3f660"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dd9ad61232f709ca08979dc21acb345f490dd542102f58dabdf1b684c324e95"
    sha256 cellar: :any_skip_relocation, ventura:       "0dd9ad61232f709ca08979dc21acb345f490dd542102f58dabdf1b684c324e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4ac0bbe87ef2b7be97d9f3dfb6614c7ef1657f39c37c67d96a1d31ea75353c"
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
