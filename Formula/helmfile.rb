class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.137.0.tar.gz"
  sha256 "233fc11612d79b5170db579e8f364caa53e311c585901223996d4f7fcb511837"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c02deadc2fc031ecf7be602c6e7de3a86f62361339e0cf00f5685eeb10c897b9" => :big_sur
    sha256 "49b9618982634c73b19c63e04c4e07e8c9bfcdea8ee6acaca9f765daaaf26991" => :arm64_big_sur
    sha256 "3ed1c8b7f9b1414468d0e39dcd957a19c574e51a4b83f4b03b3137d77d4524b6" => :catalina
    sha256 "384720ce0bb8472cae17f7c04c7f0103f31221b1d96d9d92543da8676b38d124" => :mojave
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
