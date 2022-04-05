class MongodbAtlasCli < Formula
  desc "Atlas CLI enables you to manage your MongoDB Atlas"
  homepage "https://www.mongodb.com/docs/atlas/cli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/atlascli/v1.0.2.tar.gz"
  sha256 "11b324e1024793fb0b82b98e67838e4060e137bdc176180ed94fc623a275ac24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c62a5c6090337cd5f5ca2a263b368d2b7ffb9726b2c6898a2cb8950f62c5327"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67d3076b36e2baf2b51c8d18c22262b6e8bc4ae27032c73e8d131f0c8e76541e"
    sha256 cellar: :any_skip_relocation, monterey:       "a18b531fcc812871153591c63f1b3c2ecf5aadd87cf09cbc2e7ee6e7cc5969b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4cfa23a66a0a0e943a9266f2b20d0d0275b241484bc622b1335ee252503029a"
    sha256 cellar: :any_skip_relocation, catalina:       "cf7d64b19fce7e0c570343f3bcbd29e84209e81c99c2368ab6283a549aa282fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76a08351b8ab071c93a7c8ddcc5c2d8a30eb611f4448ce63d7dd66c4dfd69f93"
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
