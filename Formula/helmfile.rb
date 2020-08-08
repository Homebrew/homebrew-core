class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.125.4.tar.gz"
  sha256 "395809d0a3f2ace382d8d9af9c17945339081adbdcb32f05c294caefe04c1a7c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e4a5e3fce588869d6d873001fb0d742c6b08245a86e77bcb40711bf3960e525" => :catalina
    sha256 "722d9114b99d315a33b0a68c02eb3b46dc762f7cb974caf89a8d23b2e3df6b3c" => :mojave
    sha256 "20796d004a954278ab22b9b4ca6e49ec2b987de3a2c5a9d334751c40d8e527e1" => :high_sierra
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
      url: https://kubernetes-charts.storage.googleapis.com

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
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
