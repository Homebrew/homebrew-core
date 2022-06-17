class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.1.4.tar.gz"
  sha256 "78e030dabaf114d9359eeac4fac1bce1eb9ee68ffca0b6e6e32bbf3f3189d0a7"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54c1d34e83c571213c85ebc55a6f4ae9019eedca663183a0fddd2d3d0cb70594"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fa8480b3d1d2e8d2f09629313c76cce3537fc63897ddede32a07c9522b3bb9f"
    sha256 cellar: :any_skip_relocation, monterey:       "7b4dcced7a9e3a6c4b11872b72ea9c2a364833a59ac15cca1915c8246e4169ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "4afc190b141f73e0cd83716da034af10bb659f90ec70b4d76c151bb7cad8791a"
    sha256 cellar: :any_skip_relocation, catalina:       "8b6dfe2687d130004c4629f31873a9d8c754918a012aafd6bb0c6d6129d867f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4ee4aa14862ade7443f86eda01b64eee55698eb6c569620c796a73877de468"
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
