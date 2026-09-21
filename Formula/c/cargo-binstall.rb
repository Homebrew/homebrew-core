class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "e86f3c97853d21ac62b053b177f7920de3a3967f81042b441961087c98938fb3"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3726b8768e810cae60cf8fef282ec71324cca499608f051655a174e4b8e7789f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6522ed03de02f9d2907eb965654016702064a253dfa922a70a09acba3f8dbfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87596c3c146b8e348794a5eebf6afc70302e3fb2bf85afe07638aa8a73237a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "20e1ed3f942403e79ce3927d356e273ce2df6333879d24bd7458690849eeeee2"
    sha256 cellar: :any,                 arm64_linux:       "c4c98a387ba4c09f131493218c2edfb7bec308aad6ca777804ae623fd7e35b6b"
    sha256 cellar: :any,                 x86_64_linux:      "b9391ec2562ab45cd3fe034b663583730ea3487004384d14ef13af31e8a60bf1"
  end

  depends_on "rust" => :build

  # `test do` block resolves a crate from crates.io
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
