class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.143.1.tar.gz"
  sha256 "0e02970b7457463a9bf1638598c4079ca19f7076972dea24d5b5c4b276eddc3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dedbc148da9d481f814a8b01751f732ec0400050073682b450736ac764aeb57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84a666f8abff9257840f3e4995c6752402986d578c9e85fb3d70e33d8f0f59a1"
    sha256 cellar: :any_skip_relocation, monterey:       "8f6ae9db56794f0e6d3740b048f18bab09427846262b380571290c9eb379d11c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4b5daccd48bb739f1e20b92cff0f35fcecd8d08d24ee739d93e7253f5ebe795"
    sha256 cellar: :any_skip_relocation, catalina:       "295102f46c9e81efb7db7dc7d18c996e35df82e2ea8db8a36cdfd264afdaa660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d187da531d20d35b6b88d1ff02f869a11de6c19484a8618fe8362320465024"
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
