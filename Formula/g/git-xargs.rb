class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "f050412c266203a0d6b4f0f427dc3023340f1aaed6e8c3d8f3aa49beeb194732"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95c54cf7ddac0552103dfb59c8370857e55becd16c2e4e755db15b684e747daf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95c54cf7ddac0552103dfb59c8370857e55becd16c2e4e755db15b684e747daf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95c54cf7ddac0552103dfb59c8370857e55becd16c2e4e755db15b684e747daf"
    sha256 cellar: :any_skip_relocation, sonoma:        "774200b89aa3097caa2029f97ca0846e0dd1e13fc856d71cbb03d79c23105719"
    sha256 cellar: :any_skip_relocation, ventura:       "774200b89aa3097caa2029f97ca0846e0dd1e13fc856d71cbb03d79c23105719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2ae97c43721e908e2656ff0293113953a71fd69be37a50049953f450a5dbfb"
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
