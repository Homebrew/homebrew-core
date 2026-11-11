class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "b07ca41ca1f6fbe9b93982b04b04505645c3640da4925315ff86d956e2197f88"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "682a8b4edacc887cfba91d59dc634805aad6b18da300750f96f1a19feecef797"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a879b46bceabf1ed9afb224de720c37754f4d7bde222c1828060c1d14f95a7f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "308dbc741826ff9d9ef3a735e9fb46f8aea8efce0163d0c4ca06b9a515ea623b"
    sha256 cellar: :any,                 arm64_linux:       "198792508ebffddf12af12df618521e3fadbb9200990d9bf56a2eba72dbe3cba"
    sha256 cellar: :any,                 x86_64_linux:      "8beaf69154b309693b36f8c596fa911f75853337479bba58e3301d1ee48a01b6"
  end

  depends_on "rust" => :build

  # `test do` block resolves a crate from crates.io
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
