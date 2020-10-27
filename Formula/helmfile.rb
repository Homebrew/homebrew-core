class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.132.1.tar.gz"
  sha256 "6b1ca959a64caabd840df0ae0e1c59bb2a4f245c7f42feb53a0a50cc84da2ace"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9742eed453ec51834550c262f61e328a8878cba06ecec8e23a797b79b2e3a249" => :catalina
    sha256 "fa9e43b2542536f38c7e53a26fbf3342ddf55e16683c12208b2f54a93ca59232" => :mojave
    sha256 "7bad25a5081cb1a62561719da3accbfa0d10836e45570324dc73abc792ff3a0c" => :high_sierra
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
