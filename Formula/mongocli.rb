class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.26.1.tar.gz"
  sha256 "d017394b05b8768795cd108f70f1117ed8898af266ae4dd3bf2a1d4f1013beac"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "954eaaa8b804f61ed4595453a4699b0aec18dfda7032a6c427da842766e1fa6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b643e606ac280d80d323fcc92fa54c9fe3ed587c828ad3d887de2d94acc8f3e"
    sha256 cellar: :any_skip_relocation, monterey:       "38e2331d451af906617aa6e8b0e84c06e6218c231f0efeb697b19655a0ccf002"
    sha256 cellar: :any_skip_relocation, big_sur:        "f378d6b2212b4899ca27fad471127d22df322da37f3066cd6752e7bf4a0533d0"
    sha256 cellar: :any_skip_relocation, catalina:       "45bcd40eb07cb42343c58db0b940bf14130dc904140dc43c0529946bfe72795e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d41a0194b784bae43f83f8c40027e42871913895835cc7a1ceb10b94a8121f"
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
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
