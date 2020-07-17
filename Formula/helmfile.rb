class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.121.1.tar.gz"
  sha256 "e2ff3e466302e39f3593d85cf50d6d71652ede2a2d7421f11f142bf3436b01f1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cc6a4410d4328d59b9ca58636d6a17dd483dabaf1467d2016144d5d0dc1d120" => :catalina
    sha256 "9e83227243996c3cea52eb7500317faa611c453c1ee9e18bd2a6d3ec2ac45c0b" => :mojave
    sha256 "45914fae78fb46317622f809e94fe3dc0b57b5f33941cd41b82ca8fc73062680" => :high_sierra
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
