class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8992127362d5fdff46695a30656af0fed32cfec4dda3645f20dde0b8d2a703f4"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef3f0e06f9846d6938bec287fa7b35e78ab89b7f63b40f2643d8d6cd4ca6e416"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39c42f826dae3645b8863738d931f2eefc83c90bbdb668deead13f2d950b601a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d265fb098a06fbd108b2523802e9ea627aa5520245b5d9a3c28eaad7c6c06f07"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d83b514c81caf619d906bdd587d1fd647e1935df2614fa34e4a3dc75d4b4889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "920490f8f508ede66e99b35011decb695c768ff66a4fca453913661e58ecae25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c9a1cb80bee4aa46978be8a71f4991efcb349d24a833e465cfdc62f333efa8"
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
