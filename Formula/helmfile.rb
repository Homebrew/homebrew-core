class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.129.1.tar.gz"
  sha256 "459611e478fdbcc3fe50feaba330bb79fded4a70fa4fcd32f0065575f1f42e61"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "41a0052d910566625eec91c5efc98d283aaa7ebf22d19c8d1cc98864ed3e3451" => :catalina
    sha256 "db3fbd6a58db0ff4b9a2df187cb707d1a9dbc1d417a0c7ec21ec0a808bedce04" => :mojave
    sha256 "532a3b40df95d5fea59317349d91c87dc67453b086e297cf54208e06e977dd3a" => :high_sierra
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
      url: https://kubernetes-charts.storage.googleapis.com

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
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
