class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.145.3.tar.gz"
  sha256 "5818185689396589f10bac974164a3ba2060f90ae197a44ebc3958b5f22fe0b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c849f7b5ac58bfec46b3d7d4ae7e563d1bc3438936284a706013863ecf6a5c1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88aea82c5de6c0b52e3435dd36ea626a2ea2e48a594076613a77d2d88218568a"
    sha256 cellar: :any_skip_relocation, monterey:       "8fe0099d0269a14d69ae65ec117e271c2be70c1b2cef830f640b26de7f034cb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "488f8ff7cfe9e04188227d00420811cb8a27736b5776f6015fb155407e9f4f27"
    sha256 cellar: :any_skip_relocation, catalina:       "18f9235b703949d978a61c7793ed26af72a5a50558521f8dc468122664dd6699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c810f3faf3d0eaf82159872216775e51382b39436bd42d576d0516b0fd0fc24"
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
