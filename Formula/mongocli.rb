class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "bb860738146d3c62df4575741fc927fee4be4eb36602eba9f9f55777dddd0f48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25a32b44606022f20283b2fd9cff5de1b2d49fe32222b4d6dd8ae548ce75f7cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d231136f5c09c45f88d2f6489c2ae7779c64c6e96875b7ef28a2f179b562f229"
    sha256 cellar: :any_skip_relocation, monterey:       "4040b0c8723ca498573419ba5af8152f8dba63954dccd51f7a307e24ef5680aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce9f5a648f7f52cce7f974dcaef59237a7c21ef42c4bb9f8f765edb31902fd65"
    sha256 cellar: :any_skip_relocation, catalina:       "690f22d0ff9cca92e48fae6e6681284405ea513915f1d22703451eb8e10e13c5"
    sha256 cellar: :any_skip_relocation, mojave:         "75cbbb2f6aba7a22ae2d878c29f30cc784690bce855a7c4e013c0ddfddacc601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e24a77c82c0a7db4a4693bbe5c932d7aaf4c9ff866e0851573a8e76c42eccb31"
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
