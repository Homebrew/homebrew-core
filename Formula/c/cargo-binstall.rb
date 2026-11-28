class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "de3fb6e79eb58bbfca7c0b7d7ad02d6cd647d94f7c817df742b5e14ffe88c3ea"
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
    manifest_sha256 "b3b3148f761ea5a6bbeef207712eea12efe6e5df3e061272d15e30bdbf10339e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "096210030c06e188ebb24100a936294b646dc50445a411d8c2349303ad704414"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "955f110d9332e281b64bcc9513a2f0ec7b13b731ca8b13d41cf6fd4eeae32a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b379a9ca7d6de9b9bdf8139080e4aadea66cb899ebe1eac9c2795c554592e07c"
    sha256 cellar: :any,                 arm64_linux:       "91e4ad7bc7a13dc623d7befd824f84494e28e6e1dd7eedbd757320419da3dfad"
    sha256 cellar: :any,                 x86_64_linux:      "b87f00b034a35b2f869cdc530d70c473319c80117bff464af777ca702659c100"
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
