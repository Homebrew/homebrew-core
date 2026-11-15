class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "920f59113da7a09ab0d4b693c2b0d3a36cc5be9b974d146b2d6b76f572409468"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "449edc030903f1d50d94017b21c92b3a9fa02618ed7140359e1ab3a43bded8e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1670cd02a2e7f2618a29b6abe87709b755dfe47cee7f53cf7d6bdacb2af35bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a42236f0cc31a3621cd1561cce9a891473193e53de8a225830a9ae5c8662699"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a933f61d6fb2959a6cdfa09439f95da8892a23e8e50994b52932a03fa01309a8"
    sha256 cellar: :any,                 x86_64_linux:      "8feab842e787c169b7e9ff1085d8dfc98e101d0c1cd66e2ddc53a2e839f5f0e0"
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
