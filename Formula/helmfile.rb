class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.145.5.tar.gz"
  sha256 "a9e5038467f2ccab6a78e3398c3b8386837757a486f6d618dc75b28ab0c808df"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b5dd60c80e31aaf2af80dc1f5685964f3ddb0fbeef0349ffeff25c5a7646f4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5561ed7ded9ec37d12ac59971bdc888d75252e3b1ac8106088231d0ab9b89895"
    sha256 cellar: :any_skip_relocation, monterey:       "3d45fdbb8cebf21a03c0ce975c05ef5a140d1415d96aa2d135bdc75acb5f1580"
    sha256 cellar: :any_skip_relocation, big_sur:        "b31e01504b0ab296dcc2d25720e3689d4e164e5d2ab446f752dfe96f8c8f0c8f"
    sha256 cellar: :any_skip_relocation, catalina:       "d808dd9d8a0bfaa31a03e4ae635216074f3bc605cdb202391b30060036d305c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0f341d6c13c89134a90909e3ee83154ef51d486c7b114456d7373a5cde25f9"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X github.com/helmfile/helmfile/pkg/app/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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
