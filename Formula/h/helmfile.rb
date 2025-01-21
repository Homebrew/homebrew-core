class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.170.0.tar.gz"
  sha256 "b9a7acaab817f4ef3fc5453385965e1afbe940d429a58332d3cbcc7c67932037"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a47d0bd9886880f8b5e5cb38f4d4d1c70d9cc2ee383ff1b94c634cbc2b2fa294"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5a2ab3eb105fdaaba53e96f97394dc11e651da765da497046b637cfb5ef2af2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39be682a40945bb93650be1bf94e0dc8204d135094fd7ef0cc21e5233c8262a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "42df81cd25ae496082f72c05e85dd903e9160f4ffc83122017285f8ecc697d4a"
    sha256 cellar: :any_skip_relocation, ventura:       "7b29d72764ab5975d054c7f75cfe70aa11e94f9ff2655b9c32bc4df90d6301d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2629b71152081eaaf40eb7aaa0f3ea152a91b3fb5ae7e64e508ea8e8d318ddae"
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
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
