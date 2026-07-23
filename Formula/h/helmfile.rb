class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "d300b6329f750838923a80f89cb65afe8e4318ff796a71d1163baf9847f92c89"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d0f38244c8e7bcf2b669b6a54feaba27c2eb81d95b9100710aa794f94e47390"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "127bbffcec844a1096df839a394cd397faa700a48e7be0341a579f058b2f180b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7e536355f3a0404a0d37dc257e9d60fcf99c3b965ec79d82d7a8c5d38777f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f1f03d6527c99bd215cd6ac521cfabb582d89be12964acc01d389ef5e9be5fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a886e5fd7e051df43c323ad20ca1ce2ceef75bb681820345526aa1ecec0ac0f"
    sha256 cellar: :any,                 x86_64_linux:  "a71e82de3a13f07d10392671296d5ee896325524c03556c5ab7cc04566f1277d"
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
