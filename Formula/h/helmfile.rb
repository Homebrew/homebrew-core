class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8428bb148e6c53ab9a1ba136b66da5257c69dc46ef04703b9674aa2535a2ff18"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd18be5cbc46fb56e0c096dd0ee142f96e07e2f4097ce5398bb9a2dcfb721037"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac0508efe54afb8ee38b4d2a3ebfd35e2c2fb06d6a46a547cfafb54ace1d6e13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f0f632df2e03681f4d39d76c45fa5201614fa3be5e0c9192ff3d55934405eed"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b265a27781f1e5748f835f8cdc61268ba2be075a48bf113cc40ec8e4847ad53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a03b9f6221cc72ac826fa03f3841fd20e7da3920d7266fb2ed02c367982d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91f91810b20b8d395548ea2af80524c4ab558686b69731b4b6d60890bced403"
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
    system "helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
