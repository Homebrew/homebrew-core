class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.143.5.tar.gz"
  sha256 "893a1a092ca6cd0146c1bb50f880c974732107ec0b6e836b1e1fa95883421371"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efd7453de9be775e338d27de865ce4e7942dfe943812197e7f2d489391d37bbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83524e0fc8e7f5824e8fd391f78c8052ea8c272234d4cc510ecdba4057264e9b"
    sha256 cellar: :any_skip_relocation, monterey:       "4cbdf92d6c646bcd8a3835b073076b46b600d8b88ed3b9da7366a345e37e8708"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8d9a3d36e516c03fe651f77fd39b365bfdbb6e563d0f0fb365747b2614a1be5"
    sha256 cellar: :any_skip_relocation, catalina:       "b63b91e167b141b0e8170602713b44181aed440cd19498517303ef64b9baa5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b53f686dd0539344beb9bf8be0aa448f00f9607c36c8a030d6501bc715b04b"
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
