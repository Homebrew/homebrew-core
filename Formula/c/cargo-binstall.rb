class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "492dc8b92a4e3177ac5fc9bbc9c05d1a28d63df627f8e732272ae35816df2e0f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "206d5e6e8959cb18839332391ebeca1217f370072b3ba7ad17def355a46aec81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48a83db64ca4031b8a5956856b7c3f6576f9a9b7ceb923ba40aae3b99989d56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e9587fa99c20d89f3f988c188b147dc3c8308f58624fd6baaf71a7195f02d80"
    sha256 cellar: :any_skip_relocation, sonoma:        "79632aae2056d8140eaa732542b3cd44137520cc8d30f6c6bfe52704f3d822d2"
    sha256 cellar: :any_skip_relocation, ventura:       "80676e70b3639a87cc48a0f9f889d37be7931a192457a390490fc3e45ae32ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f6a9185ee67767c71520613ed954ab9b07d60f6e59ea14323a55334817f50aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edf4127656ac8b050f1ec89e29db0f2ec351b2590dd9a7ca3021e49608bbb496"
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
