class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.164.0.tar.gz"
  sha256 "c12630d3e209888c7b80f025b9985e6dcbab46884b733c632bf4e304273fc66b"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8d8f5344d9753bcefe65d4ca5042a43cca1311a8597af5b9fd074f6ad1a33a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70b7009fc65e40cd5d673aa780998ab6172ec5d86211e6068659b492adc9e15a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e9ed70910dd8eaf4fb833c8aa6b29635caf71360e859b616f4c9382b491360"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab427de623c841e8ad23d860d3c2038726f2d5273102a6b8f720a9f2035f5460"
    sha256 cellar: :any_skip_relocation, ventura:        "d9794c03c66e0221dab7dd8f59ac8db4c60d362fa44ba6d8e6da378254ca5bd9"
    sha256 cellar: :any_skip_relocation, monterey:       "77f38dc641b3218a0a3ea1cb3e391f8621099abc09081b8f680b7f5256d9e377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d4a7f01597de8da1688370b7960eb017bb9c4e95565b25fadca12c34ad89cc"
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
