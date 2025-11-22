class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "e2f25fbab9c5dd33ba94ad33cda0312e96ad28620c5944d6edd787014e4d79c5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "507ad6c0d64aabf9eef8d7fc99657c6258d2de6851123ea46eff6ce021b3aca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b637cefdeed4aaaf6dccbf9ad595e38f9ce8401488054a10f0f9617e20bb1e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f8ff1a54f1cbe82dc08ed5ab46af90af4323f0b1f799d5643b9d637073c466"
    sha256 cellar: :any_skip_relocation, sonoma:        "996fa8cabb210c624ed1c2805217033b779b9ebdd71b53d37068528bcaa7de7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d36a94044d643cb61748f12d1872122b4f718ea93c4d3d4331865a3fd490c82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c962bbcffcc11a766ebdfb26767f6dc368c19ae43e477b2fe20ca94988370a40"
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
