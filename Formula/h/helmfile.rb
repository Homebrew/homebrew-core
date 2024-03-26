class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.163.1.tar.gz"
  sha256 "f6f25651c66d5ee3bb6edb9dbb0b45742e8e804f6137166e9145610df9aa0004"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67cae815bc473a89b659f49dc36b57bdc192e10a9aa3dc9640a6438d0e8f1af5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd3d79ca209c426abe1903fb87d0e0492ba132d726e5fe5879bdb1a915e3a899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c1e1eaacba3345a839978c60ace81e90531c25058ca9aa310ff7a1958558f2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c9f8444e5ad9756c462fca5c1725f508e175af40cb60409779bd65deb898db7"
    sha256 cellar: :any_skip_relocation, ventura:        "048c040b4f667e6cb29481f8456aadaa41f874f2265b8a579ea31d70659ea35d"
    sha256 cellar: :any_skip_relocation, monterey:       "b0a48adc0ed3b9529643a38fe241a75a57b3d4a1f1e4f7a55d2ca7d093e54130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b1098b2f9d27f7f75e0aef5c1d96d2eb0a80133980e676774ca4001fdcfadb"
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
    system "go", "build", *std_go_args(ldflags:)

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
