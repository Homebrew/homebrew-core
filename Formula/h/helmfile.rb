class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.160.0.tar.gz"
  sha256 "e34b7e491e177effd71686f059be978dcf51ba63d9fa13c74b5956786aafd0c0"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d6d936d3cbf1e93076a6e06319fd4ea5c4336f94895b7ab1e7d947443bb0f73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db86b89316167e0a4411df8c3b48235dfd53b8690cea32cb02c9b53334636a69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0bb7ef3429b1ec32f4f15f577e396a3c4a81062a26c50644002d9a97170b90b"
    sha256 cellar: :any_skip_relocation, sonoma:         "02f691b3adea4a7a316a6f7d14cc4abf116d95cfe0538e838fde5466a8fd6142"
    sha256 cellar: :any_skip_relocation, ventura:        "28e88e71c4119e67f2fb398c5beaa10cad9a47c43c06135857598e944ea020e7"
    sha256 cellar: :any_skip_relocation, monterey:       "150a5824738cd9b717ad6edcd79fecbf45d2a1fff263ef7f96c77aefa32db9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d383b4b72da33f5464eeccdabad933b445fda58c993b5bf38ebf961f59e75135"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X go.szostok.io/version.version=v#{version}
      -X go.szostok.io/version.buildDate=#{time.iso8601}
      -X go.szostok.io/version.commit="brew"
      -X go.szostok.io/version.commitDate=#{time.iso8601}
      -X go.szostok.io/version.dirtyBuild=false
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"helmfile", "completion")
  end

  test do
    (testpath/"helmfile.yaml").write <<~EOS
      repositories:
      - name: stable
        url: https://charts.helm.sh/stable

      releases:
      - name: vault            # name of this release
        namespace: vault       # target namespace
        createNamespace: true  # helm 3.2+ automatically create release namespace (default true)
        labels:                # Arbitrary key value pairs for filtering releases
          foo: bar
        chart: stable/vault    # the chart being installed to create this release, referenced by `repository/chart` syntax
        version: ~1.24.1       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
