class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.138.7.tar.gz"
  sha256 "ff3bea881cfec9df2aec05b6c587dcb146da4643234a159f11cbbbf5857cf69f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48393ae93677ad3e6b4f352b2adabf40f68c023a392e6432bbf06f6be9fe9d92"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b81421b090b929afbef11d4f86b58216aa034bf144a53ca102542c64987918b"
    sha256 cellar: :any_skip_relocation, catalina:      "4855dd7946c00299f5ce59f1e78a1bb004a8212bfa9684b216f19db868c3f434"
    sha256 cellar: :any_skip_relocation, mojave:        "0670ccc48c8f626a8809df8516ffc47505334311810e97c26356eb002beca0be"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
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
