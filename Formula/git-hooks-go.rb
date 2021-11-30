class GitHooksGo < Formula
  desc "Git hooks manager"
  homepage "https://git-hooks.github.io/git-hooks"
  url "https://github.com/git-hooks/git-hooks/archive/v1.3.1.tar.gz"
  sha256 "c37cedf52b3ea267b7d3de67dde31adad4d2a22a7780950d6ca2da64a8b0341b"
  license "MIT"
  head "https://github.com/git-hooks/git-hooks.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b44ba2ea899d62f65370ebbf36356d2534ccd3af038f72e06774252f8770546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0162bfccf604080a5c520a02bf84cb006390935f8cc59c0ef4c1f7f08d071cbd"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd0c4ba88b9fa6debe95d147e069636e78093976eafefb0e245185a313a6a8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb65c1d92db2e31b8d3d2447e3c4642a1865658f9d8075a381439ca311b2ddde"
    sha256 cellar: :any_skip_relocation, catalina:       "c297503f6623a3c258c84a887225f3690433a16e97492f7071cc0c3ebee0d073"
    sha256 cellar: :any_skip_relocation, mojave:         "c5323401f5a7f37a895c9b7b579f10e75fccf0f83ba9fa4bfba4782cebeedbb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e2a568a671db87621def2f35483cb89b4e7b58605ef724db8912868c76a327"
  end

  depends_on "go" => :build

  conflicts_with "git-hooks", because: "both install `git-hooks` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"git-hooks")
  end

  test do
    system "git", "init"
    system "git", "hooks", "install"
    assert_match "Git hooks ARE installed in this repository.", shell_output("git hooks")
  end
end
