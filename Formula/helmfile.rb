class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.116.0.tar.gz"
  sha256 "893d1cda2f06448c781763def76fb245b11fcc2aeff7ffdcaaec598edaa9bbc5"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8453cf450c677b6f3ad60a87f6ed58c833e4e85421098ba3de086c373dd34c2" => :catalina
    sha256 "3a64b52d6131bfe853d17a66d0f0e7750dcee099472d3ff8f757d3d96edef693" => :mojave
    sha256 "876a82f73e214f6fd2f90a70c41458a57cc76365f1e3a4fba425036a33375e86" => :high_sierra
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
