class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.130.3.tar.gz"
  sha256 "64fd8bebe0e3e64f3c0a067a7e9cd3fdd35de1c6ed3559dac24aea457fbe7e58"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec4be5302f716119b98f5f04a724590d7e820ad13d2c8fff60b4da6c550c7c51" => :catalina
    sha256 "630f6526620a3b849e5d6df2c774bf9e8e3e6df94a8a75395bdb0f8df3e65c06" => :mojave
    sha256 "7a4268b58416ab14d225dbc036ffe31957a98f0cbf913c86b6634cc114e478c1" => :high_sierra
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
