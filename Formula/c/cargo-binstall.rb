class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "2fa54da8ba61acd64eeaf826a1cb67e721583155021b1ce4640c5373d7e6f57a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d01430e896abb1d3d4c4f504c15faca3345e35df59088f1217d0cb20ed6a44b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb277279f0a7e21ecc5f5a0af1222401e4d9d1d4a1566a1623d77f9eb790d582"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc1016920e1f744d573460ed6b4986a083806637d8d74e31e97b6e908abbe818"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb993c362e8169c570dc47e55dcdb9025e008fa0a8e02d78a17ae33dfe5292ad"
    sha256 cellar: :any,                 arm64_linux:   "d63812dcddcc3bc54eeff0abbb82183db8b4ffb9a16c733b3693c6bdbc141d7d"
    sha256 cellar: :any,                 x86_64_linux:  "05bace01f70fb0ba06b0275009071bce32b56620829cb4aaf1ad0cf3eb0ea359"
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
