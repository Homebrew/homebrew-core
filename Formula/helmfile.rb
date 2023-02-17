class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.151.0.tar.gz"
  sha256 "3f6c872c85ece40fc063db2448a9fe970bc58852aa5e0199fe1e9d523c9a3556"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "965ad9f8bad3336befd6652f996795e12a7cfe475f1e0971d792b0d69834e4a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38be686de273798e1721774d3b4c98f63e4bf212265172f12cdc370d82b3eb25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93a9333a6410754524b14b06b34043bf9a015d1ba74d32d6472c58f00ce08d36"
    sha256 cellar: :any_skip_relocation, ventura:        "e70a6b4366b47b1ba86406b7a238bc0398078ca94f0f98b5e543f84065bf24b8"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ccf7126fce05235b115fe3b5deca9788abc113b18f6bc6c93fd48498af9277"
    sha256 cellar: :any_skip_relocation, big_sur:        "79f32fb31c0a3ebd2d67a566bb2863d3ef93d957bd2308b36a01111222782680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac292568f1768b8fc0c3cccb99d795e1b11304411da23b2277e18bac00775747"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X go.szostok.io/version.version=v#{version}
      -X go.szostok.io/version.buildDate=#{time.iso8601}
      -X go.szostok.io/version.commit="brew"
      -X go.szostok.io/version.commitDate=#{time.iso8601}
      -X go.szostok.io/version.dirtyBuild=false
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"helmfile", "completion")
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
