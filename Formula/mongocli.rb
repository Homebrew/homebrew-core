class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "eeaa49e9035bd434a73dc80b71f54281b7bc371c03f82d9497db9552543c40f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c91091fbbe879c42af22795d5089a4405b00c7df1d93fbc5dcc95ccf852c281"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b813616589e35e5f7d5e3a2ad07ef98f63d8ee6262cab518cca7d72b9191b8d"
    sha256 cellar: :any_skip_relocation, catalina:      "f284bd08f68e6474e26aa739c9abab2c7fabcdd9da57acb2c4b8a6384bd24af3"
    sha256 cellar: :any_skip_relocation, mojave:        "f5af2da49dafefa63a03d8460a1557085bb66ab82d6fc47d34fb5282ba23bbc6"
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
