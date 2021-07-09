class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "047a9d9d52382b7ddb796ba5878dd9c002684c355a76309a4f5e3d12e0d85a35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "779aff7d29c5f3e78ce245320ef6fee655ea58c0bae752c43e4fdf757e53a6d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "26d9a04bcd53e36f6ba293f70eed92cbf9261305481c34b957355bc81481c605"
    sha256 cellar: :any_skip_relocation, catalina:      "e682e1ef1c4b73d86c2e8cd8b74d2a376fa396f0b91a4a3fcbfc3465eee46b47"
    sha256 cellar: :any_skip_relocation, mojave:        "3e0244a434dd90566c795945f1425b6ff0e28f70b625c108fd70866e49ebe56c"
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
