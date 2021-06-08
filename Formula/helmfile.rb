class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.8.tar.gz"
  sha256 "0477f15aa46528fcc91183711574ec94b95e6f3aa685a98ff4b1ced795fe2514"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56cc341b500d5e27a9fa9642920fee0aa2ff04dbe88410725453b596c1829084"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc149a7f04b15e9adf9220dd65096c1bb01257e0cd0bb42f40febf4bb8f36049"
    sha256 cellar: :any_skip_relocation, catalina:      "dec98f745ff84d74c74550f34db130a377d3af0b85a2f020a01334448dc0d7b1"
    sha256 cellar: :any_skip_relocation, mojave:        "280e92d2cf9152070d587e570671120cf3fedc39407c3bff7196496a123a971b"
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
