class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.1.0.tar.gz"
  sha256 "9461e5a801724dc796da7f8e648a2ecfb250530edd5eaf494053b9ed21536405"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^atlascli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97bc96249afbe130d092059d6500b81bf2f5f9122d80192280d3723970a85c99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c117fb8f7a591a6e2aab919dfeb3acb8959757a4f71164dfe63e92865d01542f"
    sha256 cellar: :any_skip_relocation, monterey:       "a011e8d904dbbbe05a760d2234c29ad86d51876be7733206b5d98811703f3118"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad07db6373717e20d262cdea0d0d46c747c78113499980a49336b3ac721f1792"
    sha256 cellar: :any_skip_relocation, catalina:       "d14c859ce5e914110cfce3804474132e17e79e0f5dd4be54654e84e09044cdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364dc1735a575aa60718c6392bed496e2757b79087415cfc177992d05e55e0dc"
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
