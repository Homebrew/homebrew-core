class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v3.48.0.tar.gz"
  sha256 "2ad82be8abe6dbc7a482ee66e95c111968a7842d7c6b66d97dd6d63381770a51"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    manifest_sha256 "f46358f47628883497508076c362237ab60cebce3eeb1425708a4496ba538347"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7db8463d2ba3353ffd48f2582f7567e0b965a3661c5683067a1407b79a55a5c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e197444c58440dd05efe2b9ceaaba4f6d2a79d2831e2a853b738452ece6748b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3cc1f97fc9b5df8d8f8a339c0d8b382f83664d0349ad3c53ae1efef37ceeb25"
    sha256 cellar: :any,                 arm64_linux:       "8055cf266a0e34caf653fd74a68a80a91f31f80ee5746cf690ed4a3dd61613a6"
    sha256 cellar: :any,                 x86_64_linux:      "3e33b1f36c6dd0b2bb18c47155684eebd7e9d142df8cebfba0669e811153efd9"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "tools/similar-code-sidecar/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    system "cargo", "install", *std_cargo_args(path: "tools/similar-code-sidecar")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")

    status = JSON.parse(shell_output("#{bin}/fallow similar-code status --format json"))
    assert_equal version.to_s, status.fetch("companion_version")
  end
end
