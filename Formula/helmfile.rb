class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.7.tar.gz"
  sha256 "f6162b1f8b6a9d8421fa69412bc4e041a9d6b01e2e2b03358aec263facd4a888"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85d07b50b82fbd672961bd89a21cf68eea394c035695a4cc1ddc643ed34d5ef3"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6fd3369b1a5ef02a2999631fa177d90d63d5a1e533f4b2e25c8a0368d5b82f7"
    sha256 cellar: :any_skip_relocation, catalina:      "18e8d2f91e8088541696b0f483230642b9028721db7bb44014a67df26ab6160c"
    sha256 cellar: :any_skip_relocation, mojave:        "ff78d92875d8ffd24b5945875b242ae45dbbb94546fbcbb26b39208a285fae0e"
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
