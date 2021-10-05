class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.141.0.tar.gz"
  sha256 "7e912f4ceee6cc873a16ff63ce85cf0ca6af9b03e5a2ad00af0d257de7e2abd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4be733292844c502d3bc50b5c18390c25bd6a2c05b594a9a01239467a1df980"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d3fe4cd1e4f7452b6803f91e87a204143277e646f3027f51a36657a85391357"
    sha256 cellar: :any_skip_relocation, catalina:      "2a270bb6f29e1ab7f37a5359a4a67d8bd51892b10b0bb787085e61e920ae63d5"
    sha256 cellar: :any_skip_relocation, mojave:        "0274248fa6e5ff952a0d1139a4610931588e13383055d2fe6656a4c621f56120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6ded1a0a33218421e7edd365d813da8fae78b6f513faff70af03434680592e"
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
