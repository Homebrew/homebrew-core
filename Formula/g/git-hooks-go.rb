class GitHooksGo < Formula
  desc "Git hooks manager"
  homepage "https://git-hooks.github.io/git-hooks"
  url "https://github.com/git-hooks/git-hooks/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "c37cedf52b3ea267b7d3de67dde31adad4d2a22a7780950d6ca2da64a8b0341b"
  license "MIT"
  head "https://github.com/git-hooks/git-hooks.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "96c499525232ba306ad32f0c06fbe845d79b5946fb69d16ee2d1a54b61807db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "76b874212624080d528a0f1cb2d966ff7872ba2d2f7f3c04c7f7e98c30848f3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f8ba5517228a5d259c8ef7df2651c15f19a6e4b03308e536bbfdf41ed87cdb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d0e39f15e97b5304db3ffdc34c9d5425340adbfde20bbf1c7f42a3e9b60b223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b44ba2ea899d62f65370ebbf36356d2534ccd3af038f72e06774252f8770546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0162bfccf604080a5c520a02bf84cb006390935f8cc59c0ef4c1f7f08d071cbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "fce68cc9ba35d46b49ec29ba5bb3256702566ffee4c62820e55f27a043706d20"
    sha256 cellar: :any_skip_relocation, ventura:        "ca8f15aef832912d96b0df4f61890c61e61e3e4fd174aebdee7ba25e7310d167"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd0c4ba88b9fa6debe95d147e069636e78093976eafefb0e245185a313a6a8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb65c1d92db2e31b8d3d2447e3c4642a1865658f9d8075a381439ca311b2ddde"
    sha256 cellar: :any_skip_relocation, catalina:       "c297503f6623a3c258c84a887225f3690433a16e97492f7071cc0c3ebee0d073"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "72bdb33fbc10fd63b3be8cbd152512d10891081cd050a905521c691a08ba58df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e2a568a671db87621def2f35483cb89b4e7b58605ef724db8912868c76a327"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"git-hooks")
  end

  test do
    system "git", "init"
    system "git", "hooks", "install"
    assert_match "Git hooks ARE installed in this repository.", shell_output("git hooks")
  end
end
