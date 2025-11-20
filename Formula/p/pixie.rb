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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e17b0e1ecc5bf561d54cccb31a1303c348bee8bf51f640942463a7d6a8bb5dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c7fbaafa23de8f05e452d24747a4edd4c8a0d61a0a01b3ba664ca804c843e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76f8833feb8e94f8f7fb33848057603d35acf63c1d6acdbfd02d3a4c22e863fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cf672d31b3b683081c257958eb297f56ff5f0b394dc48f51e4be862751f9bce"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fdd739ced12415fabcad6ceeb96550171e1b585143f274376ec56f776c83d90"
    sha256 cellar: :any_skip_relocation, ventura:       "afdfd7b18e2528f563336d90b53d9266a72b86d847df1afac796fc70f7f6e8e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac95efb5aa8d4021a5c102cfcba35c8f5be2ebc2ce5f310cea8214699ae5f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da530afc94d1ab1753b32d48e963b6cb6e4c45ef4daaaa2cad0255e54fab966a"
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

    generate_completions_from_executable(bin/"px", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/px version")
    assert_match tap.user.to_s, shell_output("#{bin}/px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}/px deploy 2>&1", 1)
  end
end
