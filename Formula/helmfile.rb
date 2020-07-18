class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.122.0.tar.gz"
  sha256 "091ce326f7c6186559c86231a01539c8ac20a14ceb73fd0527140b8b84ad94c5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c811d5781e4dbeb50f36245d2315626c2893b44877c53bcaf573fcd0062204fe" => :catalina
    sha256 "e79e547a3df588dc261f77f21ea3063145e304b222528877a5b5b8b62b4f1a59" => :mojave
    sha256 "b5a78bc224fd2276b85648cc6fa35a4dcfc9fe7eb4676ddac405f06be866eb8e" => :high_sierra
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
