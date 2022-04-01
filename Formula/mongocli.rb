class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.24.1.tar.gz"
  sha256 "b63aaa77c397f6a6438142559551527d12fc3abf58dee3a903d3eaf4ef928868"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd81f8626fe5e3c50be74803b89e7048f36bac8a635401fd170169de96286ffa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c00e7bb2a0e263f328b274bcb304bbc12f506548c5454ffda0708ef3ec5d45f"
    sha256 cellar: :any_skip_relocation, monterey:       "79df811351b86ac786aa4faea34e54dd3e9d34d3be9ea564b33bbcb54ee4f697"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b1dbdd4060d44b18ba4ac3e77d51d08503daf63797d8a52f3e56641691ebae9"
    sha256 cellar: :any_skip_relocation, catalina:       "0550ec59036339561d05c5b13c9e18bdd1e39cc866e9cca5f2e3a7cfb06fd146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d43bc0064a2083e281b01710d7651ec8e1238fa0ddb02034a9307ee93c456bd"
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
