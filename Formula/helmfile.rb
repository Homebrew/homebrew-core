class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.0.tar.gz"
  sha256 "23baff955a189e2642948d1e33f91b87b6ac4ebc36f96d2ac913b3841436e911"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f354a0a85c65f4c50f1a9fc16cb4d2c53f36420fa25320f82637beedd153bc8b"
    sha256 cellar: :any_skip_relocation, big_sur:       "460d9944786fc927461955a3aead9c80523528e1a9ab464d2213416f65605289"
    sha256 cellar: :any_skip_relocation, catalina:      "200837ce43d034712ea69c4c37b980b77a8ee29b60f839086262dd213f4d6a5d"
    sha256 cellar: :any_skip_relocation, mojave:        "a6a670916bd4cccd57dfc9f405c8956a5bcb3e0e8614570f4f869d0bb7ce9fe3"
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
