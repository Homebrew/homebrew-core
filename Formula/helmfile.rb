class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.143.3.tar.gz"
  sha256 "ec0dcf2335e06100979c00ff4a5da964931776f4c528bf2d546a63c3cb83bb61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4876e8fe1d90e1948fcd53016ce12f63784946db8cc1fe5bcc6bfa3e04617681"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bfce7329410d0692550f82ee5460009d4b521a23a8a42fa3c844b46ac9a370b"
    sha256 cellar: :any_skip_relocation, monterey:       "6fb4de7e675f5b642ef4519f8534fa9928654d506330b60b8857441260af5cf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddedff48bc5c100b8d5766a88553bc3934615b5900274aa2e5e1feeae8b72aea"
    sha256 cellar: :any_skip_relocation, catalina:       "d0b2f3d5b78ac9c81055b2191142ba1e839c66f31026654de1efbdd3ca17940a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a35ecba4cf6a49f76961b23d624754da8e7169c6c7b3ad34a1ad1e480cfefc19"
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
