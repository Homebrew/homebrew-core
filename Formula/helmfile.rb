class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.140.0.tar.gz"
  sha256 "ceebc1ac44fb828ec098f79a34434dc748d46e49c9aba5ff0fd4f45ab36a65db"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41f4bb88d498475f1db28c144e207c58b8d917b1f4d97a96d291f1cbc9bc295e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6860d31efbb65af27d821acd5e7c4c54e166f921707eb3f0623ce7770895ae4"
    sha256 cellar: :any_skip_relocation, catalina:      "f112f7f0489e7214e12dbd6ec74fa325370e992eca10c5c79d5dd48a1476fc95"
    sha256 cellar: :any_skip_relocation, mojave:        "aabc9618eba3037f49830c0f09638791248e28df9de7c6de4fcec141f0421910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870306f9af887397e8362f25750f515ebf4b2930d0a173235302ac49d562f1be"
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
