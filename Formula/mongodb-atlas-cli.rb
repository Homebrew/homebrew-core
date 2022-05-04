class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.0.3.tar.gz"
  sha256 "68e14e188096d5303d87bc673782e9143ae925c635787076790b1607447e3645"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d8bd8d53558eb15c33f351e0fc17a194a2a4eba3450fbf117640615c574f8b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c09a27b0be83355ed47bdd9a2ae1f3a0001a0d956d5b885c2a2f8e3a57a09ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "0d23a205eb8dbe181f30cdb22deb0ba667e3101a3af00b8463f8278cc7f55684"
    sha256 cellar: :any_skip_relocation, big_sur:        "96f6b27fb0ad29dc7f0c7a8ac104ff24186ecaf40033153615c75d0eb5c7dfc1"
    sha256 cellar: :any_skip_relocation, catalina:       "2f228db821e617f05c66a52bc2499ec56bce708da0163e0ef80e1d11c9600b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6476f418353e5ff1e7aa83c6cf9c6fd447cb7d04ec9c2522e9698feed14c4afa"
  end

  depends_on "go" => :build

  def install
    with_env(
      ATLAS_VERSION: version.to_s,
      MCLI_GIT_SHA:  "homebrew-release",
    ) do
      system "make", "build-atlascli"
    end
    bin.install "bin/atlas"

    (bash_completion/"atlas").write Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (fish_completion/"atlas.fish").write Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (zsh_completion/"_atlas").write Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
  end

  test do
    assert_match "atlascli version: #{version}", shell_output("#{bin}/atlas --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/atlas projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/atlas config ls")
  end
end
