class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.107.0.tar.gz"
  sha256 "921653bdf356ec2bbf0d83fe65cd562efffbda7fd1f29407ee489362f6ad8d9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "79842d5a51d91ee8e6469bb4ec49c77f1554d6b661dc53ed13b1345dcb244906" => :catalina
    sha256 "ecd91f3a60cccb41d92e8691423300f8023938f42b42269e58ff8e8c1026ef29" => :mojave
    sha256 "0017b5d958cfe8a54de4dec1f9048359b4cb1116efc67e510b23c6c765bd9061" => :high_sierra
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
