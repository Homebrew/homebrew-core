class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.7.17",
      revision: "2f3f26c6bc929992744f303988ffdf99e998611f"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^release/cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc7e8c53e17a17deda1d6eeeb55a8634a3eaded33505b82d4994f50b1ef01323"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3de8badc2f4474447d19ffd313b866ebfe6424bc98159ebfe88b417ad338ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fa86c4af601eabdf86d108aa0fe581323d90eeb5bec11002ac9d9162ce231ea"
    sha256 cellar: :any_skip_relocation, ventura:        "9e6d794144f90c7df8347019e42b71d2e3aeea153a310251ecc8b00a4608c163"
    sha256 cellar: :any_skip_relocation, monterey:       "171c75e6d6e9cb274ae6f4369dc50b24062706cebd2e43edc631a93a53dd7c81"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8b9a0370907737cc31da6c344cb608a8743d743543271da932b51c15fbb79c6"
    sha256 cellar: :any_skip_relocation, catalina:       "7d64f3d32cbefab6381512b07697a6f53d2914f87509e0ac75cbb284b2f6fa71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fe4c81cc2fa8418b3b5568bc23ac524b860c42651f5c63dbd43881a301f00b9"
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
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"px"), "./src/pixie_cli"

    generate_completions_from_executable(bin/"px", "completion", base_name: "px")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px version")
    assert_match tap.user.to_s, shell_output("#{bin}/px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}/px deploy 2>&1", 1)
  end
end
