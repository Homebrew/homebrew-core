class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.158.1.tar.gz"
  sha256 "5a38d3fc4345d9986b521fe389b7a5da0bc23bd3835cfd48bf1e51fd7214a932"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1990e03eba2bda864fc13e45f6e05ee72f00abfcef402b219153ee1d634765c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12fa027b92ef7d49ec36b327c762ad906b2450a2d2f165f060dff7e7e88f47e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a790183889483a63e1b95da1d3bd847c1e4fdcbf20211eac8298c02af8d5df36"
    sha256 cellar: :any_skip_relocation, sonoma:         "4662da46a694d047484c6d5049b128b4f87b81fdaab62f1c1d0bbb7fac46349b"
    sha256 cellar: :any_skip_relocation, ventura:        "76d2f5a55b76da8aef724e4645a1f146ef87b082c8869ec8eb6ee5ef90165f24"
    sha256 cellar: :any_skip_relocation, monterey:       "4a5ea9835a9ce4a2be790c21990bf43114f3d066d6657016dd86f1197402f116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebcc6e27958db27521b9d24456aef5bc54a07fdd56c6ba83dcffc71c59317fb5"
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
    (testpath/"helmfile.yaml").write <<~EOS
      repositories:
      - name: stable
        url: https://charts.helm.sh/stable

      releases:
      - name: vault            # name of this release
        namespace: vault       # target namespace
        createNamespace: true  # helm 3.2+ automatically create release namespace (default true)
        labels:                # Arbitrary key value pairs for filtering releases
          foo: bar
        chart: stable/vault    # the chart being installed to create this release, referenced by `repository/chart` syntax
        version: ~1.24.1       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
