class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.147.0.tar.gz"
  sha256 "85ae176d6907bd885c1c46f1052467c9b30791192f364bff9e24aec9fce9d0e9"
  license "MIT"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05a8889daf03461a1be3a84e2e9913f78d132371d65a3071464b5c7c5643d50b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd1a0621a5982fa866c0d0527e6f6e82f21882a7442d069ccdbf3bdcd7a9a544"
    sha256 cellar: :any_skip_relocation, monterey:       "749267a58464dab136367863cdf98aa66ee6e6bae01a485f30f5448fc1aa884a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f408479a490f7be26e0686c5efdf42695a8ef75863eea9cef8e6c477e04f472e"
    sha256 cellar: :any_skip_relocation, catalina:       "e74551f5817a7d7af78471056b6a28aa2f4c0b3fdb5da164f5f126f4304976fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e0e7cb67f62a062624cedee98166145292e6ccb31750c52a91ee3856b694f24"
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
