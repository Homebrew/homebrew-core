class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.165.0.tar.gz"
  sha256 "00b63c55f60107c36ed9328974ed5a9266a1794bc1e19461230ad2463eeffab2"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e5a22d45719ca6e1f8e5aa9e7bf75b048de231e8260aa06cd6eb5319d11bf03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f80f7b4f047c360a9effc33d5b5400e21d48fa4491d01eb59e89ddf1ec619c4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccfc6d5bb9fadd082c9ea700eaee40cc8ffd29f62ae29175ee5c12964cdd83b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "feb3b1a694a9692683508bb2103e8817961efa94869232d2ce8c34cce116804b"
    sha256 cellar: :any_skip_relocation, ventura:        "0f40871a9ce48cfe5867951801d12d1d9d6b29b64ade5ed6e3481ab3912b2189"
    sha256 cellar: :any_skip_relocation, monterey:       "c7512a4371cd02e3ca912bd7a5d013b0e968e5f5e15898572c7378bdccbdcc52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "562281b70d6682b6220033928470bd6194acc1d7d45aa86e3bfc505c1b0806be"
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
