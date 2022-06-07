class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.1.2.tar.gz"
  sha256 "b051685fdd61e6152ed914d4084046408bd2fa64acd82e16d7518af16ca65e25"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1480c96c8ecc91ea6c8d64f0054b5263d1d4575ea47b82b7daf3e9b3d20eeb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93f9ac2cb09fc697f22130bc596b1ed81cb951cf91aa4c68a2a580a6d3550434"
    sha256 cellar: :any_skip_relocation, monterey:       "0536985b1cfbf42634a14cdb4b3eea20f7f1cdef3a93984a04f1b3f47da18a38"
    sha256 cellar: :any_skip_relocation, big_sur:        "211aa326b4c11135442a8dd567bd1130126c37b767a4daffd54e535d9d33192a"
    sha256 cellar: :any_skip_relocation, catalina:       "fafc7ccc385e1d13e457b98cedc30b8fa29dd10a9c55cc8111130b2b9471d9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e86a3b78c4dbffa5204a4310f33ebc8608e30f03830d8f49ca3da0c956f2310"
  end

  depends_on "go" => :build
  depends_on "mongosh"

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
