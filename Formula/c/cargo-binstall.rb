class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "9495aae52ca36a560d9cdc9a7563d2e385813e76d42904c683f847e9370073e9"
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
    manifest_sha256 "f51773fa05473efd69de3d1d73e009d3cc8e5a183cbdd5ab060e970dad32f31d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4358e7d8bd20c6f77e658b9a67fb59b4fad2c2221a2789aa7c2d685071e32dd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22880c2b38d013ae60713f8fb8d77fd7d8747e76d30f961cdc86a38fb8707e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e7735a06e82d669c60ce09358593d66b9a5bbe1d24cdbd75a7b1facf46025bc"
    sha256 cellar: :any,                 arm64_linux:       "2df470c4df38c6ea0195e10821cb67ad9d452a374eb941b5dc7fe582f14a6725"
    sha256 cellar: :any,                 x86_64_linux:      "2ac8b8e11ce984c5edcaf6df6c98cd67a5144295ac57076dc6c4225d049579ee"
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
