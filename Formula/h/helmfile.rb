class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "87c3926308dea3f48036abe6d75b4b83e749c23080f7adf3c24d92495b81a771"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7edd7bdd588781ae916bf7e7819891f6337a6707f93af65fc0101e872be6c3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1bbabb64300c8989862ab3a2eaf89ecb19471ab0e9ec2b29894505c1c73afbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65fe58a1a403630c16cf270265365ffa88499ffc9cddf97f938f1d90d9ce34e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "05b1db65b3174f1803332d7c67adbef7583fa12c7a83a69c517e5599e5085f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20b898306ba40cd022fb69ef500394004da373fe0f36a45517596d21554a2f4b"
    sha256 cellar: :any,                 x86_64_linux:  "1182ba0abc6bd4bd780040127c45a540e64d8d5e72865f30d7d18482e85484f4"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
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
