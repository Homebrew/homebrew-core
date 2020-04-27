class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.114.0.tar.gz"
  sha256 "0111649f21b7a7fd5758277307572c71ee3cd0fd2bcaae0921614b7ef3783332"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d70ac9d01a11e70154dd928ba736d0993d29156e4388cb57f73420fd5603a3e" => :catalina
    sha256 "d9addc27b1d3fc5a481ade5fa6625b8420d049f02918cb01f676c8c84f350b18" => :mojave
    sha256 "b18e56c327513f5ebbeada9e1a62e69c01ee98abcf628750cc2eb31ab21716e0" => :high_sierra
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
