class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "acc51a53c5da30a33745c3cd0de813f2a2c9f3866ac986caac7c8b8ad01600e0"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4cd3bb34e39c0648e0d3428128c1445604c4899e4471cfa55d791f38c1a7223"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf2bc4890401a6f96f621f4a9fac204e276e8ea5fd1ae8433e81c2d71f078f88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc3664f2503cd3c2a9db4b1230043ee65f73e99593ac370981d902477d016bc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b6359dd1d8f9a439adc6f68f2f6fcdc3aba9f543d189098ed3556ba53e09b5dd"
    sha256 cellar: :any,                 x86_64_linux:      "37cc79c0a801e790479f0683a016b36796d7c5af46e2f9c2672d855ad60d8c84"
  end

  depends_on "go" => :build
  depends_on "helm"

  # `test do` block adds a helm chart repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
