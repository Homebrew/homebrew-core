class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.138.3.tar.gz"
  sha256 "7aa7c6f4b64ccc87e21efd62ac56fd69ae2543cec6aa0efc60a45688ecef76e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e638118710ee6b1dbd35d68a5d69ddd6173fc74dc6399e0ccfab227de84ea8a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "e346b2062d4eeefc4ce572034ff5786d685ff0e7afae1e22a67675f173779162"
    sha256 cellar: :any_skip_relocation, catalina:      "8da57f526fc2a750b2c0ffc2188f2e85dea0075e3f905a84a31df3cd598763ff"
    sha256 cellar: :any_skip_relocation, mojave:        "f77168617bd88f9280f3a1de5299bcf7b2c3b3350c85066878cfd4a6ec36b44d"
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
