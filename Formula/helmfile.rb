class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.132.2.tar.gz"
  sha256 "17172fd44d53553130bc03f8c53592ee34c3abef062fed4106bb6616b0e4a264"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "000121b006aa32c2835be4fc7d9f4d6e0efd142ef34da3d01a6f1de94ac8aef0" => :catalina
    sha256 "bff824acf11cdcb2226b46e0f296599b939782a1c8679a88c58099c2afb0ff8d" => :mojave
    sha256 "4ebca3dfaaa7c78b0449ffede248786525a50db5a3cb35165564f7791e621f92" => :high_sierra
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
