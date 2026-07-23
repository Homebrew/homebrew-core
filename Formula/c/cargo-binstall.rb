class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "a7d5349ce3fb7883c911ae7c4154770d5782214ba2c6c65579e8e0b339c82764"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e6eba13cda1680f35955e9979fb328b1226bc005dbdd69efda70738b7d59294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3ceab049d2ac04618d31487856a19f24442f447a87361a9a90052459c550950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86ce9b5d78cf16a955a568a85ca8b9b954da4f0b405a09185ad2c739818afd1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "40ba94044a993084bf03aa5cf1d3090b4f6a1b306802de47f7618096a8c8b201"
    sha256 cellar: :any,                 arm64_linux:   "7d5e153b4334d1d3b82120dc4ea123936feba04334308b3323bb91603d541bdf"
    sha256 cellar: :any,                 x86_64_linux:  "820533f4d23fff3574e2534d802d83602f3f2c7bed95b13783fc5c49d713109d"
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
