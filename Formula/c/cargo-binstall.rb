class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "56d16d7b033b851a7eb729f6ba8fc2e821581687db896fdc483b503a7909ffa1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fec801e1357199b5b78d32996a60a5491396b5fea7120ace79ca0b60f7a4d443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "411f494cff251c6fa2901e72cd25fe652ed047d398052a02c3c20232c662af78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29137adefef09c98ab592ac82d765a196404813eaed037ef5843d84b292c95eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "36f764f05540bafb449a7ca8206bfa7e1562a1fcf1c128750afb608ecf7340ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b5d0cbb04252500264fd55034b006b28aebeb4b82dcab2ec116422b0d21ab2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf2febe5423175aa27c605a99e9283d8218a82b5db32b71196b9ac6778df2c4"
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
