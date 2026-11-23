class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "916370931c502d9b33f7aec56737b990d65e4b342c946506cdf8e8a9259c0303"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    manifest_sha256 "caf75e69b556338f3c596340701fbd5be7a0d63abedc9b0b29f4b693481d7657"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e487fa7ff1dcd2392bb9b1ed7e2a86586712573c6837dd37c870d2b32eab9514"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61e80b03e82f9b8e68289abd30883f5a4a706acb57b5b749900c0fb272964122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f93af1aaba0460fceff9ea110d896d537a2a5f99a6ac5ac5789be996ba07ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4fe4c272ed5227bf1f7b12a82a8a8c7cba0633f1329d62d13aa648fc773dfd9"
    sha256 cellar: :any,                 x86_64_linux:      "19007cbf1f188bcdc5c1340874133a849e08533b5c1ad6cf91c0030bb3e7693e"
  end

  depends_on "go" => :build
  depends_on "helm"

  # `test do` block adds a helm chart repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
