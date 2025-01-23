class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.10.22.tar.gz"
  sha256 "8524d94cac544e7c700eed045d22be4ce0fda7d285218b751c58f1371927a6f1"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d903fac75fa30100caea6cd3378c6af0108cddc580d7abd849231670c727595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd14324a35f3054656e5f42160d3a290147e39ee324c760bb018da0a1f720eb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "accc8bd48f4fdcd1714b7af2554d7f6c9ebc9bd35c58e5a98b24f1f7daa34b64"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d6f1300d2bbc506fa89b23648dc1bac9eda0214597b8de679b4bb247353362e"
    sha256 cellar: :any_skip_relocation, ventura:       "735ba931278bffb33eec24cd503b5bfb03fa565c1be31d858264aaddd01bab89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b244290e9c3d2598fc68c5277bfe0c4fe751d2609adf396f75cab3b3d58d6810"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
