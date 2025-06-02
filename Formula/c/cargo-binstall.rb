class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "3980b886bb2d7cc7fa3fd59111538af4ede130d41f58dceb50faa00d065c521b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5860a3db624f3f2c2619498ed85f0da7d0c280dc83cd65cf95d566ebaba7a0d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8144abd09add935d93063769d78d178416c4c1c2a320447e44610db4d55c3fc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "251d65bc670309277fe51abcf4d35010fe40080302034e8c91c6e26eeea90937"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ce423686adb6a7ac91bdee2564a5cb41863a4f5b518bd2b8f113bdfbbf280d6"
    sha256 cellar: :any_skip_relocation, ventura:       "4223ddd3f40a11768e8c10ed553ac352178ce2a3d214cfc0d27b3001d3b780ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b5e60f387ffc75b90a10dc8d4a38c59bc421270e0ce2f6140460df2142f9ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35673fe55ff1af9f5eeb722f7b9d038a6d05fad75791b12543bd5fcf5c2b943f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
