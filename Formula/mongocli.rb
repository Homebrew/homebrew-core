class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/mongocli/v1.23.0.tar.gz"
  sha256 "7b52bf6626cf991b771fc7a62ca7c0ec6deb7012fd5a4c5ef8794b711ee69010"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c92ce39199f55347e48c3ab18dfa13cc524a725654af8fe446c33607ef84062"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d472e20348905da057c88d9c6e69815e09f76bb7cc45fb0d6ab082755292be0"
    sha256 cellar: :any_skip_relocation, monterey:       "90c338b68f87ee30f9eadbb8bcacae3b079a70e805cda8343dad073f4c664824"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b83976f2af0aad98d4374e80042be7c9dc7c7b28ad0211fff35a45fed698d28"
    sha256 cellar: :any_skip_relocation, catalina:       "18a9d3e5c96071d43637bc2ad25152cafc8159ad2c0d8a24a51f5e64a966bfcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c50080a1f8f7344994079a6255be7e14fccfa2c5b65039c79f8f61f900e9075"
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
