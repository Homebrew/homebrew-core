class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.144.0.tar.gz"
  sha256 "fc767d10ec21ca464caaefd309f410d96685a985090c237907a22bd983112c62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1590692c9f2abaa461d3efa8d48b72fe1fee5e1c652724b4f7ce4a5ab3616f35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19103ce6a9762ee2cd1a4543461d519c4037783bcb168466dff8be5391fbb896"
    sha256 cellar: :any_skip_relocation, monterey:       "1ef56c0a9486b873d14eae8b0b0e66fba2d40b54e958d384afe2eb875b7efc8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4571b0303c58fe93278a2fae1576146afecbf0dde9b384d598a565bb52d6a9a8"
    sha256 cellar: :any_skip_relocation, catalina:       "9608ee96d6b2844a3bfa52219c56a73ff8eb4ca8ba13d242bf96f31225c12e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae4fb50bea0ba92e62741ce5bd59c772ceecf69c5e75cb0be0dc0c2890c4c2a"
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
