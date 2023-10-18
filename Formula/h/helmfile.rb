class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.157.0.tar.gz"
  sha256 "8578370b100eb8a9329eadfc4fdb9e8f6f7ab83c631aa8100e05df92d423f7af"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99e4d83c1b2bee0e3027120bf838c3a3d9974bfb0cc52d4df97b2af874ebd8fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caba1f0d954d429efc23d74acdcbf1d769f121dcd6d592460043750c3c9745ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee08db0c433b79ef3d9f9a656cfe5676ee849109e2661c4f88cf5cc88a244c93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fdb4bbb877544059a40a4d9d7861f8afd7e409bab2c692c619fea50db3a6c8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fcc502bb1ef6a8900044ea3c54ceb6b3c3922c92649fe60553b70f5f0eed13f"
    sha256 cellar: :any_skip_relocation, ventura:        "41d9176d654e38559fb4a469f5dd61f7bd14a89067edc783672fcff3b72b7ec9"
    sha256 cellar: :any_skip_relocation, monterey:       "314e6ba8f36fafc3ae660a5627ce6eb547e56b90edbb65a17d98a60fffb6241c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e906046012f627241b693518aeee2bf3289bf98d65d144cfbb3ca4cb82ed9fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3543c9de6fe086c5071364e57d84d6abf273168dc509b85da55ec1bb96758b68"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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
