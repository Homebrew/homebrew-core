class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.17.8.tar.gz"
  sha256 "18dbb56919f3503ccb1133192835ddb809a856c7c99212ef4066ef1cbdf08f9e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23a26aa1619e0a1fa5d7b484e6de9f2f372b7ef8416b29de82c5dbfd4465b30c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd73af5ea151c4f0d49aafce3ad7cfb625d0e43875f9ee5b29533d70af36c5d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91cb2d40b3d81553a2583f1a8db030dd3c11dadf1c0f6c2b67a9b956e9c4e7d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0bd559165a7ba93901a6bc2ee50a0a579c49a26e3ac704c2d654c77ecfd4a48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fe2e06245dcbecf1e0bfb43f08b280d4f3671b89b03019718ed6045648240f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f061759163bbd163495cb1b5558ad060cc2279a476e391a069eb264612f1ae1"
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
