class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.142.0.tar.gz"
  sha256 "5475a041f0a1eb5777cc45e3fb06458ae76b1d4840aec89f2fed509d833d0cde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29cf096405cc834e7888ebdee9c811a3e375e8a43b2e045ec0295e8ff654bad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80e9c9d81f57b0331038108026263d6d9b184403659b66a976172e9dde916792"
    sha256 cellar: :any_skip_relocation, monterey:       "73e5bab63a7d9c0af77ccc72f8bca63cc8f72b96923ebfe41430a356cbf2cdeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca024a40610d455dce99ef913baee47fa1d82dc821d780b94e56a54b3ecbde7b"
    sha256 cellar: :any_skip_relocation, catalina:       "7fa829db664c78079ba1c8ac19ec75b47e9664dfc55cf79d18970070e81d0fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53ff4d7a0816b82fcd87c791e6a9db70699425931bbba96181b545a837fb7fb7"
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
