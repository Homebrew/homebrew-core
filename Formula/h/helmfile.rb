class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "cf9b4e96830c8562a6b0436e102d2117d8b2cbd9b7dbe308e6a6d032ed7e7a1d"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc3b63a85d4da093849221e7655fbefe24f4491d659ff15a5eeac369cb8de482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a7b3e153a332998843cd3e245f27784ff55a83b63c3723cc78a4e4dbf28fa87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb65696011e4aa751b40fa5fc8e86cf25a4d35b42bccfca98861ddf1d5305c80"
    sha256 cellar: :any_skip_relocation, sonoma:        "066505124cd7fa876e7eb4b85d7890811ca30c1e81a7cd88032e3facb2749338"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cee1aee8664d8e746a3e1606714ffe0032f8a9df0f311fc5c26e305cd145c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4b22e8b5d9e3030ec4abe10c5667869558a7d32d20308c3a497629b4c8048c"
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
