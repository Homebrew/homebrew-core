class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "3876e53f076a5450dce855d3ba2f05937dda6309dbed391268dcdfbaae710fe2"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af4be9eb015e77fd02fedb8c3f4ea236f254f6b125d52443329b8b10052ccd72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a936c5cc4ff89f2f74ca9e00add5c778d710c377872aef347d2f150831e282"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be53e29ddd7623aff5088fc621880533e9a949317daa413b5dab38101e003129"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ebb83a247397a897fa493ac40a69022b08959e111051b5d296e8103e2acaca"
    sha256 cellar: :any_skip_relocation, ventura:       "8c35dfb9603095563c27a96ffc9562e3cdbd55a9c76cf4547afdb19df2ce36b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dbf66b77c7f07201c0380cd5ea940b34e827d891bd15187d36a3689729d05cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eca714f2789d07035f66e75a207fecc8d2186f5c31e6fad8dc0faa73e241a03"
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
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
