class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.138.2.tar.gz"
  sha256 "398de641d142e6d45153e3274bc6a96d240a343cdd71c6bf731605ac4feb338e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d48898f44f096a5ac149f0c1cca68335f8234a0ed0e7e82ed1e9dc1ab4b1c85a"
    sha256 cellar: :any_skip_relocation, big_sur:       "133625040991e07c1d18e646b1d73c177ea5c79741b85ff1aaabdef0e8ed9907"
    sha256 cellar: :any_skip_relocation, catalina:      "0404ad747ed1d5c74bf730af84d2c0c0650d26d93609182803cb9384c767398a"
    sha256 cellar: :any_skip_relocation, mojave:        "fe94b8383c0cc9dedeb9968f3ad007a57027df574afa46e17a472f6adfac76b0"
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
