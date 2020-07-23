class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.125.0.tar.gz"
  sha256 "14ff7dd0004d19318e88d407af8d11da5f8d73755171473250a23fce9cd93e6a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "92ac4d067ae8d968ebc70d66930646eafe3f783813158637fd0867c5477b056f" => :catalina
    sha256 "a9b4928f13f8ace4b708659eb5cdf01ab3a9b25b5c7953937f3704aa5f2568c5" => :mojave
    sha256 "ceef0851b54cf1ba8c03c46111ec1c1a8cff8c7e82f715a5ecdecc421032ba2f" => :high_sierra
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
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: roboll/vault-secret-manager     # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
