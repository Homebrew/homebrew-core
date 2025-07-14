class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "c0b8a16f8e1efc3b52ea8fdf41061384311a329919120e0d4c6fe37de70fa427"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e756d1f071a4d1669c0371da45df63401c4a54635ed6d9b5579e11b5ec3727bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a55eb5ebd2c9ca7a859d5830f70333d9de4418f4247917de108006b5e901f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d7d3b8ecd32bdd80cdbbc5ce55df4261c6f58252e23ef7eb64f4cc38e138ee7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d181608e59fe6b4effd60e1b8022b5c974ef775b5f7bbe4406b5e4b53dc22df"
    sha256 cellar: :any_skip_relocation, ventura:       "251824275a2a61dfb321616bd85f20dc22b9617c46d8afd2144877d5a80c92bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a2b67a82f0a03a455473f2cdb7da917f54f7295a230ad111fb2d22c0b4623f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "485e823805d74a55ec0964a01047192b888805487bfec5848c501f2dcca2ecd5"
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
