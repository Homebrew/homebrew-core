class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "dc0021824c017c63c88792078160d0e73ad1a5cfad0bfcfb7da8d3ddb4b25cf0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8de10c6fee97243f13eabe986957d1effcff6fa0fe7ad674ffdfd7267625eba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c963a99ef4851fe60f3a3b0325d483688f45676fb934a8840840638814324e05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d696e39281b0702328518e98ef47496e1bff1c1bbf14aea1ca7d3816534cb58"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2c685d3f0613446bd2a0a4d1f12686e73e88176e8bb06bb88f59a80d6cea6eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae2fbb0fe90f946406c763a566ba11e1190324a26b6faaf8a07a12b861705f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1933b96cfe09840db2d7aba6ce08a3af273c40578c6f20474b8e2e47d9b69233"
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
