class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.155.1.tar.gz"
  sha256 "33c6856e49bf5293a1ad11578b2b5b8b9ed5407483f1cf461857f9d4b0f7c2f9"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15ef079980e69a1e89f576be2210dc4b7557c4bc8ff685563d3a6def0843aff7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b9ae214df71f0439a65c052686b01d31a246cd0d3ad8ec70324c9b54c45f6a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56ba0901f0702938ffef3928f76c8d68d3dfb8fdf3488978ead1c0611ea2aa00"
    sha256 cellar: :any_skip_relocation, ventura:        "081afd54642c629d0d284e7bd2b1570ebcd75913b95692a99d76674e9bf936b9"
    sha256 cellar: :any_skip_relocation, monterey:       "b9fd1b95a698ce7c047273f5af2bf528cc4cade4966e1ae5574a645aecb04359"
    sha256 cellar: :any_skip_relocation, big_sur:        "b36f25ba33c015a3a5e0248851dda32413ca9855af410df2e2c638e58a01109c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71f03d78d077fc116a7924c57f489e7f3729bd01af0e18b0b05dba4f627c680"
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
