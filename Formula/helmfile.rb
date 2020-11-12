class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.134.1.tar.gz"
  sha256 "dc6247e58f70b0e0a0cf0a88470e904e41b4bffe254d4fd5eb1fbd836acc1246"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f21e4940f0d2e173586be6922968f3e3339332263db7ab33ef2d3e5ef2e26bb9" => :catalina
    sha256 "544dbda619558d5f692ee449d2db1464ae7494df274a38aeea54d926779d5c83" => :mojave
    sha256 "5db43fd97e26080518119b9f3b4dada804dbd0ec652e7fee65f597e2575bb65f" => :high_sierra
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
