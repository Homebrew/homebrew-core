class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.147.0.tar.gz"
  sha256 "85ae176d6907bd885c1c46f1052467c9b30791192f364bff9e24aec9fce9d0e9"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e24a011c0807f2f725bf17717d87780e89caa308d69fea5e5fe84da5a396e334"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3186bc793353a43b9e87aad837c722c12b529d7e45b4aa4a8d096008d2399c34"
    sha256 cellar: :any_skip_relocation, monterey:       "9ac30a437a7d31e55425ebdf4de556eaad6d8ec925519a3c55b410d8f54e3368"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d073a6541cbcd8ef222ed946d7dcae7092ff24a120332598d635c350823d1fc"
    sha256 cellar: :any_skip_relocation, catalina:       "35db3950720ca8712db4b616adc5d4b0b9538681d3535d9d81a54e4cbcf1c6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622cbad0554ee9961948643ab426ba68766364c8cd1d91e697d61b20756c0dda"
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
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://charts.helm.sh/stable

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      createNamespace: true                  # helm 3.2+ automatically create release namespace (default true)
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: stable/vault                    # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
