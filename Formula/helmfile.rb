class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.4.tar.gz"
  sha256 "e74a3255dc2b4fc8013921f68909939694c022ef7575624afc370847774e742e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fac3fbf74f67ca639971443dc76acaa8bd6c1ee198841d457c4932675f15602a"
    sha256 cellar: :any_skip_relocation, big_sur:       "842b48acc907b886637fe3623c056c2e0882de68f384851e0c78cf51a881498e"
    sha256 cellar: :any_skip_relocation, catalina:      "d650e1c4360734cf5ace4779b0a6df9afc83d93279643ce7cb7b18bef8917c22"
    sha256 cellar: :any_skip_relocation, mojave:        "ba79d0f7b6d98ce817dc12346eaec2d9ff716255249cf95f56e48e6565efcc6d"
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
