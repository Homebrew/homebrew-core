class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "4be31aa5480c890f2a6261f02619614155f49be905f0c2624988bfa60c09600b"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "088912adb5c097e1341b2a22ffb48111e748d18a57158ad307e8667841e469a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e607db9686e1b3f85bed214b2541995170cd19c3cb5bbe398a6cf05ee73713b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e0d5470a67b6dec7557e4f5f7a5923851e0993967c978cc17a48f4141865aa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc1bef89064d714ed6549e1e52ee24d72d70d65f8aabda125d15eabc4f0ee02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d5f4509f73f472ec0b71be6b9749e7eebe9df0b7f5839eb9b83918169a7befb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c88b1fa775a9750ac64af8b4ac4bac81dd9352dfc2fb083312e106a26d885ad9"
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

    generate_completions_from_executable(bin/"helmfile", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"helmfile.yaml").write <<~YAML
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
    YAML
    system "helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
