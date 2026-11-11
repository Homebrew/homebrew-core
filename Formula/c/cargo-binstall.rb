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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59ff0e3616e2f7cfa8e45e1ac53e1ace44bed60ef754d9ee05c9367022257cab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9686e2d8e0c368880696e6dd97276d14088e34257fd18640c58f60e20876e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0125f94563e2441cb1781e9d45db24d247fdada2b331d84a9bf78e70321da4c4"
    sha256 cellar: :any,                 arm64_linux:       "7ea84986c07b0c72c609c1a7122a14628dfcadf37724e6803e8fb9f96ce65ac1"
    sha256 cellar: :any,                 x86_64_linux:      "003d6572af4bd3b4fa5c163e88a361bc3d126a3e8e214c6855cba3ecc4f3368b"
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
