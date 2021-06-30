class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "8f62ab86abc6e0fcb60a232c6900234a27707ab5d5c87eb5f3550181d9094fb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44db755d06d629b2db35323fff42f42567243e3b4b32413c1c0f300c4c177516"
    sha256 cellar: :any_skip_relocation, big_sur:       "3cd0bc211c6c3f10bf6e52dc0cb6102b8b0157d805363a8c81f9e36be9c03300"
    sha256 cellar: :any_skip_relocation, catalina:      "a1361b711f11529f4007f06a20276f356bf0748ad4ebf36af92bb994054063a6"
    sha256 cellar: :any_skip_relocation, mojave:        "5d3b3a574543ffca2a7b44f909909d3d4bcc1fac680c98d39ef7529d455c8890"
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
