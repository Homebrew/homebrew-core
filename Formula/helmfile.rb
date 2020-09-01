class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.127.0.tar.gz"
  sha256 "2ecfdaf6cc78ec8900307fa1b0b216a1496eb69ff177e1a3360b85ba3a41e2cd"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "756896f8c5ccb4c9d0d28ed746dfbd9a9043b36a788df74dbfa45c0b0a4d5464" => :catalina
    sha256 "fbb021d92b0afe18f760415ee3fa76dddb19db4d0ac42e668fe0c4f561d03b2e" => :mojave
    sha256 "b8d8cf4018e98721f586ff887a01d8daa21a091a9cff93c8a7b2171292f7810b" => :high_sierra
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
