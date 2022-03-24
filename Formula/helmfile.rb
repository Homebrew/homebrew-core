class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.143.3.tar.gz"
  sha256 "ec0dcf2335e06100979c00ff4a5da964931776f4c528bf2d546a63c3cb83bb61"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4233de161d4048943caab86ffd7784981a3724c63ee13a2a6bd14ace8505e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "327eedf53d47be2028a97a3893ee12cd0033b3793f154c360dd75dfee5b2346b"
    sha256 cellar: :any_skip_relocation, monterey:       "f24789cb502b44eed435290ea6af95228eff7f9a1b35dc615d92c158233f4aa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7647ca24217c420933accc130b3a6a08d0d41035a29c539c7129ad05b80353f3"
    sha256 cellar: :any_skip_relocation, catalina:       "a44a4c64b33978668fc8c2ef1fa497f7acc0fe84bbef4de684fd95c82e5529f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81eb70d38dd4a71716ade30b7cc75430c570e57f4b216180b7fd6c4486b88eb2"
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
