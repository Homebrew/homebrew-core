class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.122.1.tar.gz"
  sha256 "cfe247cf046562cb30b7ed2ad4764458d1066f9c082fcff6453ac78ec40b1e6c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "000a7568b93a35f3cfd240b4f443673d92e590c377815359ff966c4dc88560e1" => :catalina
    sha256 "78652841f6186201e565c2f0b36a730b8f678b29133b3e1b10d7d7352a286084" => :mojave
    sha256 "deaecafdb624d6ce4648acd8cd5fc6e108b518ec61a91bc6b326e3e9be300477" => :high_sierra
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
