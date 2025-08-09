class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "047d3c58be54eda727ae69c23320ee77413f3e508505e8c9a53081d0c213e1f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3521aa31f32cc193d27f89a39dd1bcb2f4dc90b6c64faf152faddbf8adc4e916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0aefa975e286877b2f0a189b60ef609661a86df516c7d4a427451f1741c17d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d9cd567104790208e2892d74942e23d5f831635303e5389b78a7806da09a2a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "542c9e85dfc5ff1e9eaf2b2d791cfdb45f3636bc235662aded178eb0f36dabfd"
    sha256 cellar: :any_skip_relocation, ventura:       "f792b61c1ee715516e50feecd184164a359c3036e4c3e583ce54511bbf14593b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76c6a0b9d7ffd5773f1963295651920d501d3e005d38f842eaf377eb6d7b736b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfae817060be355b2984f9eee2c861a720bf48ead4a9a14c6c667f7eecb5e71f"
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
