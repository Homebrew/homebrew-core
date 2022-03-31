class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.24.0.tar.gz"
  sha256 "e06b5ea8a1a11c451c1a9a3012387b92ce969ecf1fa8e7b9b500d64be3a6e475"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7f1f06b80b65f92fea77e0b39fe1d00443a66f1b30d0c734c8eab75e5120a3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adc7fdb8752684214c010319ee7020c90a36710c1807112b91d8e3ad2dd95b3b"
    sha256 cellar: :any_skip_relocation, monterey:       "4c6f99c90fb7092b4ca5f91433a9d7ba2097d989561a85d0d1ddc9d70416b5b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad194a907fed89132c0ad1965ca0d025212d977ee684d37f6b04334c6a5a5f69"
    sha256 cellar: :any_skip_relocation, catalina:       "cce730578c3b5db4458795a38e6e4de2054c28add6646bcf0afbb0d12b433532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "783d363825cbe2efc02cd1576816227e92316bf9cabbc5130d2524a68a65145b"
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
