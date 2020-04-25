class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.112.0.tar.gz"
  sha256 "2d9599329a83b7d18fafadd08c38f7dc6b5dc66144d5fcfd4291f91b1e3b5cad"

  bottle do
    cellar :any_skip_relocation
    sha256 "da6898c0278a289578a3864d03015ed32163d2a149251f1701dd5a848aa67290" => :catalina
    sha256 "aefd1a740181dcdfd17b232405d5920da2bada24f69b49fee3e3179ca1c3df31" => :mojave
    sha256 "4e67e2a8c375c4f494ba87ae7d8449ea93ba1daa19f0cc4e26e35b1a4e215162" => :high_sierra
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
