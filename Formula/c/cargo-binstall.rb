class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.17.9.tar.gz"
  sha256 "33ffb0260d498dbc8aa1cc933bd4cf3087099897caedc976448391826562207f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be4cca7544776c79aee620ed18c8fc5eb17de6b218efe484c3df312f1111ec30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f9f348ce9646c5bf35afb6103154f05e4046cca0319946f20a089d1a6d88579"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6553836410090f98bf0609b6fea2fea14ff6f9e4c3841babbee1af11652bfa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fb43b8cbb1c5486aa66a78284091274eac8ef5876d13709bf64ef6285f3c02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c2c9406eb22c97126d337aed5bcaa42c9e6c67ccda1ade19bb78054874b95f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eeb952c1c426213e2548e51752b2dcb8b2fb0679ce9c66648c3e0ca1e1dcd8e"
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
