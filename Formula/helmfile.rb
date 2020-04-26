class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.113.0.tar.gz"
  sha256 "ad8cb7e6e62dc105f82ba26d99a387570fa872345c8cdb7aee5a109f488894e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "50f71cf782a3a91bb0573699d78d9b2bf65eb369674da02f4577f12f03830e53" => :catalina
    sha256 "5b340e599e42ce561f3e936d6c9229c5a86d82e35d443927dbb64bbfcee2b1dd" => :mojave
    sha256 "11417a8a112a9da3793394a8f7402ff6614d73d4081e3449c2b1193e7eed47b7" => :high_sierra
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
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: roboll/vault-secret-manager     # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
