class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.146.0.tar.gz"
  sha256 "c61f9efb150793a253660000fa929b0a87552b66bb2a27373f39e93d54ade932"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b2c7a9140c12329d638344c43b1bb39574284400aeb259b53b418a6499f39e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f094d4bc89f3f0371198ce62c10d80bfb836319416cf45092c17427b6fa89fc"
    sha256 cellar: :any_skip_relocation, monterey:       "f746f36cef873b8fdee38e80dc81d741ff9f494f2294559f46d6c292460abc6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "03773d172f97be151432ab9de24662bbe2f260b55cec304f271a691a143e3cac"
    sha256 cellar: :any_skip_relocation, catalina:       "e4bccc8af039042385afdb4200cc738c57f6b5db820de945a6ff61cda611fe1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3682a8ac343e6373401283f13607d749a6d10d3ea1d1bf02c110fe6b7285e78"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X github.com/helmfile/helmfile/pkg/app/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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
