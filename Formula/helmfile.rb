class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0145.4.tar.gz"
  sha256 "a2ad467614309e8aad6c030ec2f3aa4dfa4aad59ecf6a41c91e77c8179710e10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f239ea7de5b9e3c88af3ee698c85c69859ccc67ded5a3332218a6f1f61e7499"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cb354ab78e78ac78fd0d8a8e3954c4f1e6b03d5ecc8ebd76da0e3157a1e3f42"
    sha256 cellar: :any_skip_relocation, monterey:       "17f93fd9fc06186030c2008759c0936475f0346942c02b21561f296aa0497bb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e631b7f7736daafa9a096ee2b33e1ef8c688ef79fd18f3eb60e9c26addb4d6a4"
    sha256 cellar: :any_skip_relocation, catalina:       "6b511cb26ac426142443bdee90d653d3e72576ae9e004807c92299023035c0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0d763cc6cec3a9e8d13e2eaddf9e06541ea974e4dfffc6afb2cd2e795a7e004"
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
