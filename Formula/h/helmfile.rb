class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "d804c196e29aa0b7b0d8571174ef6f7640ca2fe22808d56882487a89da7022cd"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9733904870daece4ecdf7626abcb62909d9fd5be6822943017f83296c68e9e54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c29920588067d987221a892e07749f9cee73a4ef0653534bef2f3d0ce8f76d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d170772a5f6213aff593c838d7b5ac7c5397860c7d7d6db9b0db0efcb177cf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5813d7df673ad018b6180dc7f2190f0e593232242f5f1a16efdb4fbbaf451f30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c09205c0968fcd50a47aaaa49db1e88d501fea8bd866d8a01b514d3bd27e2bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b09602e70ccbe409d57149f2e9c3441cc184fe5976a4749c18b2ea6e8cd7f9d4"
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
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"helmfile", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"helmfile.yaml").write <<~YAML
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
    YAML
    system "helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
