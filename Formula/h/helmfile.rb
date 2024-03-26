class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.163.1.tar.gz"
  sha256 "f6f25651c66d5ee3bb6edb9dbb0b45742e8e804f6137166e9145610df9aa0004"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56131a6d9c84964f613850426e6f188225b72daadf7361d12766e367c7d0f70e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c00a26c01f98a12d3fc7647a0e329fa2b1bd4994db9a9e4692e4fe660078727"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74dbba8f0b577a0efa2c0650bdc63fe660f051c14745c9ecfe413f1ea5e3ecfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "c868612cbd9002494a325d0c6de92c541c9d720a49b9f25340930c0b7852afbc"
    sha256 cellar: :any_skip_relocation, ventura:        "0cd93ffaaefca08187241566abd7d2e47e90e04d6166ebaae9a37b4b09ae837c"
    sha256 cellar: :any_skip_relocation, monterey:       "338212722a5e29ac4ad89eae3b96196cf029ed623fd188c8bd36c86a7d2fea92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4993f2c735f8578227611273f2968d8486977e12df4862b2512d1071778f2ae9"
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
