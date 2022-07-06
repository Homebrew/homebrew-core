class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.145.2.tar.gz"
  sha256 "8e472b1c65cd50b214d445dc37fa6b1ef97d4b374066b036a245a07fdf04473d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6baa040bd67053b6978d0e93a92af9d924fbc8ee383e1c29eae733fafd514a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "add72b24d00f5f29612f8c4d063004627e9c6fe00fbc38dd0dc21a1159e5a836"
    sha256 cellar: :any_skip_relocation, monterey:       "8a87bcbc8725da93df8ad06663ac7bd818017e57c39300b678aab077a1320e08"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9a0348cad58fc330970d04ccc541a1bca52c7d141fb25a22adddee914cbdc18"
    sha256 cellar: :any_skip_relocation, catalina:       "2f2154adee2b52aa458a9448b928d543eca831a6377420f0e408743a492b4882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116dadcac56e41a37d5c42644f15a5d86a666c7729d2bd05bdc973cd974fc875"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/helmfile/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/helmfile/helmfile"
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
