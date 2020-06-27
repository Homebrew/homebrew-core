class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.119.1.tar.gz"
  sha256 "dab636955c6a57a7e52ef87f499f8ef0479817a1e553c7f5e212df20418b1e90"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5d96066c0a0f9cd7650458f9975c89ad4044bfc7ca532f5dfc50bcea9083731" => :catalina
    sha256 "c675537b56413bde89e67894e3c2fec5a10a431ec03a18f26e58f50b3b4ded93" => :mojave
    sha256 "19ad337e15e8b4b717df4466f412d0d274cd0a5df77e3b0d88b55aa15143435d" => :high_sierra
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
