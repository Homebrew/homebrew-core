class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "ba9f38f2df7efcc4a11d906fc036208e90175ccc3832146d4c6b2bd0bdc84008"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0162bc1da87fea5fbdd7a6a7a24bb74bcbdc345d2510cbe71da0b2814f3c700d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26ed47d4ff6a16272e4ebf75a6705cb2b1a433d28ad67f12037186c82f72f202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4d3303ee3d72d4dd50d52119233e41e66b42e89d5fdfb0d5222fc568385202d"
    sha256 cellar: :any_skip_relocation, sonoma:        "300d94aa6eee7f066c41afbdd9345deb9cf55a371352901cb9ae846682eb16f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3efbcb06ddf23a22ed9b431501bffff4e1ff514ad4c7a6bc16b66b2ec9a22145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65843e86114a2dab6d349fe0d81ac95aa4f7addbf9037d3b652ea3723288fad1"
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
