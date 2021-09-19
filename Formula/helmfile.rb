class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.140.1.tar.gz"
  sha256 "69380cdffb0f581ba29b9e26894e48a0e2cc2be17cffa9956265791b88039de9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1827d2ee47585aff40a5c2dbaf7ddb5a7a6852a539b886f5780fb2c2a2bbf304"
    sha256 cellar: :any_skip_relocation, big_sur:       "09422d80730aa6f32756d742108e22c86f9ae16245fc552232cbf4d7e1345ad9"
    sha256 cellar: :any_skip_relocation, catalina:      "accc78078d86156e13c51d6b68e909fb42d10fe2b4985d9656661c2df7abe373"
    sha256 cellar: :any_skip_relocation, mojave:        "b53a7b3e95735f8185cff164461260e43fed6ce3d30a325825f52d7e59e2cff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879c8b0d0158cd65edfb55b6d527f8c61cc0c1d912008ec6cdc1f2cc5984230b"
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
      url: https://charts.helm.sh/stable

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
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
