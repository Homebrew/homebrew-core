class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.162.0.tar.gz"
  sha256 "6cf1877d53c576f7e196b88f79eea00ecd8a19fd7619c84d5d396b3d3a6b1e7f"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "311e5560ae22554c7e0d6aa102f9fa1419eb33ee14a15b1108e994f0d342bfca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fd84529f5150e43177455af400122478812f58b255b8986a70bae7ba58d07de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89389108d2b762e710b2da38ae97249ca3d0c51364a9370ab95e6a823b5d4924"
    sha256 cellar: :any_skip_relocation, sonoma:         "422841989864e53cf9099872e01e278bc5667c34b0c6e6d88b235110e82968ba"
    sha256 cellar: :any_skip_relocation, ventura:        "e88b749eff126ef2b3d012d8811bb8d84290620358a00c9b7dde0160df335878"
    sha256 cellar: :any_skip_relocation, monterey:       "d73fa242508fa4d71e9eadb82967daee40b1cebf65161c7284fdb557812959d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a5f1e0365791648d6e898958e32de4dd878896c41184291fbd6bbe172491504"
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
