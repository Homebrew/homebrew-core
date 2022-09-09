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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a0a728e26998347e7b8ed8aaa24c09e9c14e33180cfe193190522b7f5f9b9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4e011905afa7d997e4629ebac4b698ad2609e6b7ebc24f26171aa64d2e19df8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b98312a2a6d3f5522b496672257548451f322b9583cc433e1b85ce3d2fc405bd"
    sha256 cellar: :any_skip_relocation, monterey:       "1c8fa172c886f05f1ba1a7d4bd0e2dab27dfdd06f36c1e0f93643c663c86978e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2dbf931849e6beb642a4f85ebfb4fd2361143ba02c3968313e10be45a90fd74"
    sha256 cellar: :any_skip_relocation, catalina:       "ea72e3b8d962011c80ca5306406a5853fc35e1b03e133898fa9a6e254d738024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad51bcee7d3ccc95fb011a19c6a266488324940ef00a7a72a56bd1d5d427084"
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
