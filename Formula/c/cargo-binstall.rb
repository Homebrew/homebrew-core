class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "5eb3e91392589d18e133f5b6e627fee6c17f830b562b316289a67ba9f88d58ac"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3f228c9d280884e5659ca9cd3832c9280ad101d99eb9ca1d92833ef0f7afefa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e570d0d29c7ab6bc1eee6689c097fd0fcc24c271fb092caf600a3f342ab72c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36fa95065ef6e135be0a45a70411145a112fe8e87cb3de0ea573e31bac5d2ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "56bb54b19a6f36647414f2af136f7d69152cb9b63ceed8c0fe47b7984d1082f3"
    sha256 cellar: :any,                 arm64_linux:   "b3764cf2cab39d9aaabc5632916a7287625ecf239b9f4748abd9537ce3f24cbd"
    sha256 cellar: :any,                 x86_64_linux:  "200ceeb431144931958cd930ccd9d75b312ab8df7b05ba14b522863a29290868"
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
