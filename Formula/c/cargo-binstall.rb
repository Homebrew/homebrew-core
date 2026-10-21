class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "69c4f4399ce2a5747d216adfaf85b557aa4d1b91d9014b52885d0fad458dc06f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58f6d86c8277448c6825d5db08b6cf43b39f130ae8a837c0a71337db830de1c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f49a0c74aa5233d67ce7948b2c00fa0207f929686f651e9dcc3fa31ae7f1353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d673c12cd2b8594f931841e3c4a1d569bd82ba8cf9990f368c6ccb4adf5904c6"
    sha256 cellar: :any,                 arm64_linux:       "a2d19cc9efb531944f2069daf1f441ee5e511e22b8d87fe42c0289b0e98dc35a"
    sha256 cellar: :any,                 x86_64_linux:      "b246e9f69d236e8fe79c72d4369509cffe82e1e08704fb6805800e055a2907d0"
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
