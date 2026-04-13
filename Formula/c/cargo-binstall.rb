class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "1ba15cbb88841757ee5edf2539bf061188091e0c38cbb19c6443baaa9de29c4b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23597c177305d37beeb117f67bd15327b5d00f5c0daba4cb4be9da59241a0212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32eeda936f8f7f19ef89e51a1171d9fcba3eefc81325102c47fe090e59af42e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8236e7c94143bf3c5c6647623406e44a540aae7d241f94c76e3b254608f80d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0077690cf0f02c9de16ace4f64e0d443aba1abc05fcfb1f1bb113c8afb4d0af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f9143e18617fa40863ac194d0627facae5e97d3d81d7d9f905d2e7b287fa1db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113d47e0ed6a66aeca912c8070bb62e4985d876d087baae3ff84ae4db646d9c4"
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
