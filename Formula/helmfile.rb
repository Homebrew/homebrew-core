class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.120.0.tar.gz"
  sha256 "2fe0df3970fd93ce6b49be941eef33a2cd0f90355ef120852a5d0964ec105c2e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "258a73a874fb4349af5c2e9fafcdd6588db0e82f492ddea6625077ad3b9de957" => :catalina
    sha256 "3da4d04558dee29e85524cbc4cb32a587eb50251548fa92b647533c6d1e5c7a4" => :mojave
    sha256 "bf87f561f5cea2e7bfe16c83d7edf3e9a75b2ce20a0e2eaeca605ac858e98dc5" => :high_sierra
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
