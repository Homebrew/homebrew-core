class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "fd3f37bc48ff8bb343e6b9869b0b070052e8d8fa3eafce0305de0b223c7bf63c"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25260fb56761dfdf4f9a75acb7a1e5fbfc00f4266fe10e802bcbf1c8b9aba869"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5a24f3fe6845a61105b207b949ea90e67c588a41606ba83f891501e26fa00e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1da212c7cc154361968a4340b749c17b88c5432e18f1a50ef4e86c1f4978a3f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2217584454d6365a1e3a067f768ba4df6e31834c7c59a177f87e1087cb2856be"
    sha256 cellar: :any,                 x86_64_linux:      "13d7b814c18e34a51f4510559411fc935dd834c6e35965de50bd93e08672322f"
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
