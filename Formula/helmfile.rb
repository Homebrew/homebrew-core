class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.118.5.tar.gz"
  sha256 "e03bd5f0780c254e2a4b2cb71a4a5a8395fcc7c626fe4b293e5f082839d6cce6"

  bottle do
    cellar :any_skip_relocation
    sha256 "757c145b8d9d71ae03fb424adf3e4c8b0a60cc10c8de922faa4370c77a4f2263" => :catalina
    sha256 "d047319c9ef67794bcb4dfabf8ae0edf424f8d327463c9775a74d9ddaedf4824" => :mojave
    sha256 "e860b8160599ef95dbd4fa6d756b41d4513efa48dbc3e785a8c50e392793a277" => :high_sierra
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
