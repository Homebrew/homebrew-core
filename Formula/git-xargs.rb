class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.0.tar.gz"
  sha256 "449ddfe8f76a3dfd79b415a11f8c531dcc1913be7173d57f269dcaf8f36b65b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce0c48982e7e08b6bfe2fd33ee320289041e2198603101ddf0a88ad443b232ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fb56e259d22e5ff91eb2e49709d2b7aeab097ee93ed4f0d8f0c6cf65c5e3eb3"
    sha256 cellar: :any_skip_relocation, monterey:       "5a6b7250fcc30c4c3e5a849a122a296a1db3993bdc58149520fffa961110cff9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5bd334b7f82daaa03a8199243fd4e1e14007a38e2c2b02768a9369ad79cc46a"
    sha256 cellar: :any_skip_relocation, catalina:       "131bc65e594516daf82f9b79f222ab59b41d2c28e6d0126995b8273ed285dcda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2be1b802aed8929e05dc203d10c5b2d084c5216c37acfa3dfd8d44256ed9daa4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xargs --version")

    assert_match "You must export a valid Github personal access token as GITHUB_OAUTH_TOKEN",
                  shell_output("#{bin}/git-xargs --branch-name test-branch" \
                               "--github-org brew-test-org" \
                               "--commit-message 'Create hello-world.txt'" \
                               "touch hello-world.txt 2>&1", 1)
  end
end
