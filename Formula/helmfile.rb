class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.117.0.tar.gz"
  sha256 "85c809104c526fd67f8601051aa1d2d9faa4cb882ac6100466c4496058f8c6a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0c81f1e6832e14340d96621dc5363f1c0780ccd5bb0d559a74bcf7e9c88c342" => :catalina
    sha256 "1129739a645bb133fab5ee0087a645f113f7731aa1fc51e340536aee526d5d4f" => :mojave
    sha256 "d645c61f86cc389b3b4faefa0920445798f8d90c9886ee4586ec473ccbe34286" => :high_sierra
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
