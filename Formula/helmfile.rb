class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.138.4.tar.gz"
  sha256 "8c6e014cfbf82f22d103098238bf9735eb62208bbfe2c16062aff8f79f6b4d24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "881e066e95f31f41d34f5ddd173c6e1e481b85c5b43fbacdc5e809306f599c15"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c2d21eb425afc90e6e2a624f48f44afb8b8334dad09187a77815736dc0235a3"
    sha256 cellar: :any_skip_relocation, catalina:      "b6dc99c0c278beda6df52dbd2417f3554f55f728396d74cf9ecf6d17729c3f98"
    sha256 cellar: :any_skip_relocation, mojave:        "4fece9e93961b306ae6c4cbf4027d21661de1fe6a92889f27509b916f75e6fb1"
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
