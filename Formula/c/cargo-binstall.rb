class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "78a514462b487556265bb68adf9c0288b0e4263c9b08b583825b1cf685e36697"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c56b63b5ab1f8fdf04e4f3bdda1d16c5ee7a175a6134a5ffd32ba53570d6b7f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "def75e7e618f80262b46254b402c59b498bdc002924c7e972cdcaaf3f5ce77bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4115cfd997d2082c8bbaecf34158fd86fca7a5697451963f957a43d94acf515b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9380b1d1fb33b9541f6af5678888b7074d7fe568e60991c4c0e4c8d9559bff4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d834560a49eb8f4707e8f102c41c5eff8d1f6769d5f5fa930f8ddb03082c66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d70a0451f59d813e0184ee2c75c4a9fb48f050fb8d25d034b15b05b9dae565"
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
