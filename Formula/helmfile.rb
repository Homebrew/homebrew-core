class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.144.0.tar.gz"
  sha256 "fc767d10ec21ca464caaefd309f410d96685a985090c237907a22bd983112c62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fac45f249d7511aeef687eb62f94bacd39ee64d7b837ff6a297b4d30632a56a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bae3ef7a4c19cd2d30ca354069fd3a1269e6cba4cef7ba0fc2147c9fe1826649"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec7ebc19e641c227c8e1690d3ae896c1f82bdcce84cddc408ce61b2c49edd9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "42fc6a2cf8de9c66a31ecf43ebd85f1193a17a37d30931554b463168c0387f61"
    sha256 cellar: :any_skip_relocation, catalina:       "f694cd40bb438a2d934139b5c2989e39646430180e0579b5209f30c44de06342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9b6a39c5585316a787d8bb15f947b345a5507590e6ea35dc7ed7652714d9d08"
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
