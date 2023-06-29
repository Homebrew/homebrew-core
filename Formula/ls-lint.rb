class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "7486a9aca84a8a6877a3c61d735f32cec3d5c89bb29ced67933996560c49c1e8"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99e258c8ff09bfe279103e10220233f759aced4b1b7d99d0a9a10f933a902735"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e258c8ff09bfe279103e10220233f759aced4b1b7d99d0a9a10f933a902735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99e258c8ff09bfe279103e10220233f759aced4b1b7d99d0a9a10f933a902735"
    sha256 cellar: :any_skip_relocation, ventura:        "61561f0dda830a67d2eea4e0d26affbcf2064dc18677e6c6439d465fa37a433c"
    sha256 cellar: :any_skip_relocation, monterey:       "61561f0dda830a67d2eea4e0d26affbcf2064dc18677e6c6439d465fa37a433c"
    sha256 cellar: :any_skip_relocation, big_sur:        "61561f0dda830a67d2eea4e0d26affbcf2064dc18677e6c6439d465fa37a433c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46fbb47e717c592556c70a6adcdcc81d62eab7ae7a2fa2ace78a62066549a457"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ls_lint"
    pkgshare.install ".ls-lint.yml"
  end

  test do
    output = shell_output("#{bin}/ls-lint -config #{pkgshare}/.ls-lint.yml -workdir #{testpath} 2>&1", 1)
    assert_match "Library failed for rules: snakecase", output

    assert_match version.to_s, shell_output("#{bin}/ls-lint -version")
  end
end
