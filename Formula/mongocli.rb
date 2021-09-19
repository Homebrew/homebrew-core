class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "033bab0ed2e68fe8484510e6a5ac56f1b4ff591d4937facd5fe4af48aadef710"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88e2e6a46be9cafaf8b97433fe0971a9eb84166085ee368038b7ae12f53a3b04"
    sha256 cellar: :any_skip_relocation, big_sur:       "5541e94b5d4157b77a8b45bd1bd014505458eab74ac080730d19c28959db6026"
    sha256 cellar: :any_skip_relocation, catalina:      "127792b12f10d83d8bc90d1fc8273831e839409c03258fcc9cc5f8ce6db159f6"
    sha256 cellar: :any_skip_relocation, mojave:        "6298ac739a2a9b3707b6e4731582e9cc3d0c5d934dda8290421a23bb18a2f4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b94d9346ac7dca647cc2814916ae732d5804ddb5aeb0bbbd52e0f76859e18f4"
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
