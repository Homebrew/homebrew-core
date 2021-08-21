class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.140.0.tar.gz"
  sha256 "ceebc1ac44fb828ec098f79a34434dc748d46e49c9aba5ff0fd4f45ab36a65db"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "869aff6c9f3bfcf5f0b4967b493bbb46313421ec075979607686e985c3acc456"
    sha256 cellar: :any_skip_relocation, big_sur:       "d21bff06163a257a7fc32023d55232f420fabefef75aeb00bcb8f4bb86e4077f"
    sha256 cellar: :any_skip_relocation, catalina:      "92f418b8fc4b88291e293e89c94e57120af3934f50c9d71593b95cc377fd22bc"
    sha256 cellar: :any_skip_relocation, mojave:        "44eaa0961efc1e65ef4056d70b3c61a1e1c085f71b9180abc79f997020e12488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbc6e4747107cb561aeef588c596ffb6e3d0ed0bd1b08da1be3faab3d2cf9a2e"
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
