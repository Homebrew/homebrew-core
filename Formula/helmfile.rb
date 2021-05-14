class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.5.tar.gz"
  sha256 "92cda493ba771bef8cc44902f975c24611ed7ad8a09ca5636d04cabbae4965a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21ab79fb2bd3eda87dd9680fb7b8309946bbe08c93f31717cc2c205f901fd644"
    sha256 cellar: :any_skip_relocation, big_sur:       "48a803adc59f6a51397dcdf112140add777e970ce7cba3de0fc0c9aaadfc3fec"
    sha256 cellar: :any_skip_relocation, catalina:      "38935df48f9c4c455971b881e57fc13e67361ace9eb6ce84eb3592cc3df64ae3"
    sha256 cellar: :any_skip_relocation, mojave:        "c5c15de8ef02360d9c2584b05c9bf50e03647fd73ab743b06ee6c5ee2c24fa38"
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
