class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.131.0.tar.gz"
  sha256 "a039829e546a7483c0e3c00fb47896b08f8a6adb6df8f58327715cb7c221f108"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fa99d4b1fd1cb823db8f496ce0dfc4b95978c8da13c5a45da2bb352be6f943b" => :catalina
    sha256 "a5435cae12fdb8d7952bae04d6c8366d8b50e91e0f146bded0608a1d1741174a" => :mojave
    sha256 "decda17823ce261b000affaabee8157ae7cd493ada03a9b3a243a8ca56c9d312" => :high_sierra
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
