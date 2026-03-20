class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.17.7.tar.gz"
  sha256 "ab3c18755513e079ccaa39727439101c1ec019c5462bc49be7297706dd511f16"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aac49583731a684ad277af22027998f54c37848b67536532a3869c4428d37ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "069d819280a90d15823560f9ec7209cce461e0f5a9ddac82168eae28eb33019e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182a1067eb78b23f883ac69b05b5f762c71fc0dc455b33b4c55c85c3a879c82e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b889a475521d2ac6bc15b65884028d7be9874add9a3d22a3f6b7b3e545c52dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2eefab07bd42a8d7dc440abed5384956968b71f88034da7ff31c69250110b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1aa737e13c5fbe25d826e38f92c54147d48c933d9c0282416ed3447296c8ad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    ENV["BINSTALL_DISABLE_TELEMETRY"] = "true"

    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
