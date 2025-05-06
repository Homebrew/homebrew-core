class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "071a479c94356a4131a8def5d71844573115a2f0c8f03f47947c4f8981704ab5"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ae2ad6453bd74e0ceaa96d4c7a9f95493d862b0c340e8568159abe90ecc3d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef85545fa4d51d3c316883e36f3f487a30522ba1f8d7a632b4366cea1a5aef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b91cfa05287d8812d3b82de71b6dccac95bad5cb57ad1b99de785baf41c21a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "68dc55aa7f6258de96d3f5698c2c950907a5e8822490634412a672da973b277c"
    sha256 cellar: :any_skip_relocation, ventura:       "7e270a710f7253a3fb4e3af2a17fbb3070338be1d1b992ee6f0546cd642ee9fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e00846dd97268f9509df5d3dc272b58e07be57406382dcb04bc28e6d2e3b3e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "702a1e345b89765895f46b08511c6edb6736077fd2e3638fdb6c185da7d913ec"
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
