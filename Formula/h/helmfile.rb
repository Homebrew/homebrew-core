class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3dee262fba1211a0bb7f90433bd44ac8f8ed05cfb49ed799e340e278d132be9b"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba52b3fc65412e05f9c51d484ea5cfce36a964501e28f3fe17b7081670281ed3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c22f43bbbf3ce3bc2b5cda9aa60e028761bed9a22540cf25eb06d8c138302555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc68923d7cb1993ea197349caad922d013bf6381184a04106eb69477c84a7213"
    sha256 cellar: :any_skip_relocation, sonoma:        "85f421893a6aedc6d2921f777b677b552418e772f3532e837d00885a30ae23dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2c56e6624402c19a3f9fa2772c093d7a75b5e104c03caaaf1291147becb44e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4c7d012993710989d9901f657ad6db4783e3c546e42cf4f5bcbad340e19f15"
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
