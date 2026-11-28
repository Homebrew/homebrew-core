class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "b0aaa99fff72cae82517355a9bf49223ee58f962612825de87034ae04f708109"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    manifest_sha256 "cd7e1c065a402a6462c932b027df8a4f61c704225379aa33b3f14e81f3fae987"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4ba1756522b6e42ebaedada6653b410185621ab5abab4878478a5af25726a8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "071a5bdfc021354aae8d9c8783ace4961c41d37879edb561d684dc36d5fd9180"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e4e9bb9bc8804f0718eeccbf4c86724a2feeb5da4374e439a0ff4c5f383200c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "808bebaf86aacd3195d9448e7f9315dfc215a425e5f5c872027445a0bceee424"
    sha256 cellar: :any,                 x86_64_linux:      "8aae3af876d916a1199dd9b417578383be02bc1203dfb9bd53459e5aa6ad58aa"
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
