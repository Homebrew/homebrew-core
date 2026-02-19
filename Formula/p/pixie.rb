class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https://px.dev/"
  url "https://github.com/pixie-io/pixie.git",
      tag:      "release/cli/v0.8.8",
      revision: "042e35639f16d32fced41939c5fbc5085e1272ff"
  license "Apache-2.0"
  head "https://github.com/pixie-io/pixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^release/cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83b266db822d9793caf6cf5a03e8317e02739f0d5f9406ca81beaec183f0146e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d6e42fdcbc35d05f2eeaffdf327ee3ca07e8e8ae7f07d418441f7446eee67f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "381b9ea04db887835776f25887660ff3377ab78da55c8e71408d7c0f023e499f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd4ac012e19ff02c9ab8717d1a2fdc49b1da39ad8a37075d3d3bc848b353b0d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c86ec5008b0fbbeab19146112fb8b9474b41c09ec3de504c30727bf119b9b1cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f803b6103598540b99c6ad6f663c4240bba259e6da0ee27f7453e3cde980f80d"
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

    generate_completions_from_executable(bin/"px", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px version")
    assert_match tap.user.to_s, shell_output("#{bin}/px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}/px deploy 2>&1", 1)
  end
end
