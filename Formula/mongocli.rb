class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.20.3.tar.gz"
  sha256 "4593179dea159a528b0afbe411a027aa00847fe75263388e52d55a96578c3176"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eae4eeb5b6342d0e2140cc979779eeec630fb038518c788ce97a30ad256f0eb7"
    sha256 cellar: :any_skip_relocation, big_sur:       "14789d66690f3af076b074535be67ac28f0e34e8e23eeba2a83d97f8f340ea25"
    sha256 cellar: :any_skip_relocation, catalina:      "024ec0fe3adda957c70f239e10aa8a285e9086eab367d2f34c70a8045ab99e1c"
    sha256 cellar: :any_skip_relocation, mojave:        "4af81c5dea666f2445f74726f6816015027f8ce14b9ca4a962b6411c55f22c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46cf06c31f763f92c4052fe5cee22515ffabef7962e03fcb2e8ccbcc80c55cf6"
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
