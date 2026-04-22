class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "f6c676221a2f6136fade1504864f8d87c49e793155517ed4d88409ee9a5af605"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3932a9466f572702015135ebd1ae1bf5ddb664a0817ff56d96e39ebf70f14a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fd5df95dc0924e69802c502352a828ee8ab5cfdc4d523ac10ba6b90da141bfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3851211fb79153329fa8180ff41ce985ec313cec3bfa6204c173517e44c8563c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cf7037bb1c556cc94f3ca806cbaf0a185ae1c4f57e420f7138a399baec98ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b41b276303cb36df6467b723a9e227c377f2ec2647f4f899a5c573e766024c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5388bb84680d6d356a40dc3329e6a1c40125fef8341cafe34cd4ce0818c138"
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
