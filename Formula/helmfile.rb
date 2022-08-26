class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.145.4.tar.gz"
  sha256 "1bfc5e805525c3629d2c28b30747ef5da7cbcce2c482cd163c0e716898f4f8be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e7bfa18780228a9b74465bb773af2d472006a146901e1fd3261c2612b928cef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8097938b6d0c6cf98b8bde4c2e9b44bbfaa2a31e283fa1793ca1c9e981612a37"
    sha256 cellar: :any_skip_relocation, monterey:       "b369ba93a13dc96dd2a69c7bf73fa35689c6209e4c6081f820eeb394f9e76380"
    sha256 cellar: :any_skip_relocation, big_sur:        "892b5448a3af1753611a3489348596f7622c6194c71a906008153adba7ae994b"
    sha256 cellar: :any_skip_relocation, catalina:       "ab66f0a8cec7ef16edc9bd51037f80f3f5a596c53a5223c2b0cd58f87e5bea06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85461da96fbeaa4f820a21a051dd9e70faf5eaf1434568eda87228df626b388f"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/helmfile/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/helmfile/helmfile"
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
