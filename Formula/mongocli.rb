class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "3bb212eea09836f73daa715f203e3074a88fcac5bf60ccec7579ede8b9dd0a57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b93efcb225f876e4fbea80d88422c916099a42615b09124cfe895d078fcc9713"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "943771007be64d3c94631013617222e6044f3c39d57e8b4b90910f2cf9aaf3fb"
    sha256 cellar: :any_skip_relocation, monterey:       "210c7ea61b37ffbfc03860d27542eaea2eda28024f6c0d1403c880efd9dad732"
    sha256 cellar: :any_skip_relocation, big_sur:        "2290b9dc16bd44d9bc95f3f45c7281f9c500a49ae83a63e4600f01fe9e92b409"
    sha256 cellar: :any_skip_relocation, catalina:       "948aaf6949544bd847793b4c2c91060ce4661e602c3f1af1645a240929fd62eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "120d157027f8fed21e5c709eb70376596a988ccf456159a40bae8dd81c5367c2"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    (bash_completion/"mongocli").write Utils.safe_popen_read(bin/"mongocli", "completion", "bash")
    (fish_completion/"mongocli.fish").write Utils.safe_popen_read(bin/"mongocli", "completion", "fish")
    (zsh_completion/"_mongocli").write Utils.safe_popen_read(bin/"mongocli", "completion", "zsh")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: missing credentials", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
