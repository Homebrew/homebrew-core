class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.132.3.tar.gz"
  sha256 "1a7524d03dd8d4861ed21b659ee2eb17aa3c19f30605f1ad157f9663fbb034b0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1d134c74ddefb8c205bbc09f5a9c06b7057c4c2c8948ed636ba249089821217" => :catalina
    sha256 "df83201f4a97a05f7bfba395e90a9e9a2e90fb33a881f9d5898aba2f7d53713c" => :mojave
    sha256 "08c3286addb5a792e18f64dacdae032993f81ffdfea0b2c9c13e67bf4223d3a6" => :high_sierra
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
