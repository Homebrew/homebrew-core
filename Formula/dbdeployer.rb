class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.66.0.tar.gz"
  sha256 "fd93ad9fe7636217dcbea52aa38d219da74bd471e5f6f4d22ac8f3ab0cadf860"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ae1f3a13e51648f9acd64f5e16b59b981bf5bb527040152b7fd65bf58a85513"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7042b818d5143ef3afa17c5a11c8757985d9e3a77934da87d98db9840b66d36d"
    sha256 cellar: :any_skip_relocation, monterey:       "ac109c974e766acfa6f4c9a2361c02a4158704aabcb688ced3852d7395509f8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "04e5be192d133dfa682a6cdd9f34cc12e4dc8f0227c10384a26667335c93917d"
    sha256 cellar: :any_skip_relocation, catalina:       "b56f76328255d851f2414c2140cc51621d5c837262da74f726eba5916f87f7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e508dc4326a3db06b4214d43d201792540032d2486491f3a0d2d65d9cbcfcecd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
