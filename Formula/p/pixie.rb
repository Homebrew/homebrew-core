class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.8.2",
      revision: "401c92c1ed086eaa35dbe17b4fbcfd96e7b1ca4f"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^release/cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86bcfbf42b2ca7d8d092ac895c72086d4efa65f30b33f14de163723d0dd6a051"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae39dedd709f92a8add505011b2f5939eeba7f18e5a8372bf9b41767d1d4f94a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "693e5840758901a9cafde136280a33628328119b0fe836d15aa1d1ea791180e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4d9c0810f8e2bfd7374d70c33427cd293adb2fde6eeb7afaa61174b54bfa94b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1ff5421325773a73e7924610a9a92edf6c755fcdca8cca22c3266c934757b4f"
    sha256 cellar: :any_skip_relocation, ventura:        "ca5612497f9bc097b7deaca8973674661db74d5cea9db12c147d7f90d78da29f"
    sha256 cellar: :any_skip_relocation, monterey:       "151c8631c02e8a3fda66937ff3e6a0a7c27bcc2a5a8faa774c9e1aa8a380ddab"
    sha256 cellar: :any_skip_relocation, big_sur:        "08a65cf20796c23ee6bce718fdbf33555b643a20bb64779d7f903d14747c8e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f25e44683314c716e558324dd012a8953def0f917f15b8c7968867c9aa32b1f5"
  end

  depends_on "go" => :build

  def install
    semver = build.head? ? "0.0.0-dev" : version
    ldflags = %W[
      -s -w
      -X px.dev/pixie/src/shared/goversion.buildSCMRevision=#{Utils.git_short_head}
      -X px.dev/pixie/src/shared/goversion.buildSCMStatus=Distribution
      -X px.dev/pixie/src/shared/goversion.buildSemver=#{semver}
      -X px.dev/pixie/src/shared/goversion.buildTimeStamp=#{time.to_i}
      -X px.dev/pixie/src/shared/goversion.buildNumber=#{revision + bottle&.rebuild.to_i + 1}
      -X px.dev/pixie/src/shared/goversion.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"px"), "./src/pixie_cli"

    generate_completions_from_executable(bin/"px", "completion", base_name: "px")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px version")
    assert_match tap.user.to_s, shell_output("#{bin}/px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}/px deploy 2>&1", 1)
  end
end
