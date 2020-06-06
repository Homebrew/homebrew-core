class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.118.6.tar.gz"
  sha256 "51a10824cb81044777783c3c41ef4ab14fbbd159bdf5789712e8bbb2274329fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "17c97b6bb13248577ef9fe9eb10b13c8de6e20c88cc28cd24ae6c0d160e2c2a7" => :catalina
    sha256 "1ff7116f764db2fef3eec8d54df228425ff870532398ed25910bdf3ea5643487" => :mojave
    sha256 "99039301acd809f0e25856f4ab11558c4c08a539c33986afcdfda81834155c5d" => :high_sierra
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
