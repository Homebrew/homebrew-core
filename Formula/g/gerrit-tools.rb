class GerritTools < Formula
  desc "Tools to ease Gerrit code review"
  homepage "https://github.com/indirect/gerrit-tools"
  url "https://github.com/indirect/gerrit-tools/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c3a84af2ddb0f17b7a384e5dbc797329fb94d2499a75b6d8f4c8ed06a4a482dd"
  license "Apache-2.0"
  head "https://github.com/indirect/gerrit-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7b31d68ce7d851d1f47f4b57adf7d6b1ba7c05ee7f8ff003afb32d2529d25d08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54c8b2ce064088d0947df4c17fa2b876610cd9bcccd76501255726e389d71b98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e944c907ac7f5bb3d468a7adfa14bdd52c22d0f0261b201f006407f2dc425506"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d1eb15677d4ed0974a06c21e3ad17fe49b543acbea1ebc0052ef0b2900f65f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d1eb15677d4ed0974a06c21e3ad17fe49b543acbea1ebc0052ef0b2900f65f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "76309e78543c82c5bba854b2b4f1fc836bc38856612cabacc2a38778fe114dc6"
    sha256 cellar: :any_skip_relocation, ventura:        "59fc3d02fe118038ef5c4b443b7c5126a693928b24dea6b685efedd4400956fb"
    sha256 cellar: :any_skip_relocation, monterey:       "e4094d8655a172f89aea151baea9298f35827c09fad7ea4d696e5c542d724c06"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4094d8655a172f89aea151baea9298f35827c09fad7ea4d696e5c542d724c06"
    sha256 cellar: :any_skip_relocation, catalina:       "e4094d8655a172f89aea151baea9298f35827c09fad7ea4d696e5c542d724c06"
    sha256 cellar: :any_skip_relocation, mojave:         "e4094d8655a172f89aea151baea9298f35827c09fad7ea4d696e5c542d724c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e944c907ac7f5bb3d468a7adfa14bdd52c22d0f0261b201f006407f2dc425506"
  end

  conflicts_with "git-gerrit", because: "both install `gerrit-cherry-pick` binaries"
  conflicts_with "git-review", because: "both install `git-review` binaries"

  def install
    prefix.install "bin"
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "origin", "https://example.com/foo.git"
    hook = (testpath/".git/hooks/commit-msg")
    touch hook
    hook.chmod 0744

    ENV["GERRIT"] = "example.com"

    system bin/"gerrit-setup"
    assert_equal "github\norigin\n", shell_output("git remote")
  end
end
