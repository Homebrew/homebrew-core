class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.7.17",
      revision: "2f3f26c6bc929992744f303988ffdf99e998611f"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80f58755f02ed012985c1db5726b2b6e1be5f677a5f627ff5b84c2b066cf673e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84adb750cc62172404c0e36437e31c05398dd5d78b068a450469302212daba9b"
    sha256 cellar: :any_skip_relocation, monterey:       "64b5b14ca3034d6725b2f8a7421bf786acd0f48e8b44ebb6d60af5774ca61b9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c170934ceaffd7e561614545df95d25d33f59bed9225e35877b237445242932"
    sha256 cellar: :any_skip_relocation, catalina:       "af6b19bfb02ae67305ce4ee4950f09d1237b5961d88aef57a3733ee00d6206d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e9a1152b89dc8a47005e908d1d67c4c22457448e939385ccab1e56f532cd478"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px version")
    assert_match tap.user.to_s, shell_output("#{bin}/px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}/px deploy 2>&1", 1)
  end
end
