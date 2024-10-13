class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.8.4",
      revision: "7a468a416fa6fc5762460ad844a9ed06ed80d0f0"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^release/cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18e20e27a7db8e12ccbf4a172e6486d6831cdcdb41e1f76b0800f55bf239e9c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ad18273604f5d22def4144d9cdaf237b2da6d3f2564e8cceefe9b96525e530b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4853ed8ecbc90fa4358c0f5772e91d64047c44c1ba96919c5e9e410d20f49a42"
    sha256 cellar: :any_skip_relocation, sonoma:        "85b4659b8f54d8f8756faf25924a0bc204cd8511fe66e2bb854d202273887466"
    sha256 cellar: :any_skip_relocation, ventura:       "b411cacab9ce597c41e24a2ac2345266b3794eea16cf740dbfc6cff1f4b6cb07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f5cb05bfa5fa22ebd63bfa33866f3a6750058a3442e6ded36d0cc53c6cda570"
  end

  depends_on "go" => :build

  conflicts_with "px", because: "both install `px` binaries"

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
