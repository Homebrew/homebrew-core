class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "0a8c262c86aa025a66a8945b390302193fa05c608b759ebcb989bd2304be00d7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7251c1f550cc7259899505388652be83aaed599c80595820216bfc7af907280d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dec89191403459a5430036d9c5f56d6b52d814968f32d0e6d02859db34962abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcf18c6a9127bb2e4e48188415d3a56f5cc2f403754859a308e5d19bf0b3c35c"
    sha256 cellar: :any_skip_relocation, sonoma:        "02b5dd0f3b1d55751bb312be2e526c6718f08fc8a10dc0d3d956c5a565b0c394"
    sha256 cellar: :any,                 arm64_linux:   "c0ed7f795bd71f421ed2f971999351640bfccce9c016dfb9a43006165e19af11"
    sha256 cellar: :any,                 x86_64_linux:  "53d9f203a491492eb0fe982f8e50eaea8175ef2f29ff019956aec3e4bcde1456"
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
