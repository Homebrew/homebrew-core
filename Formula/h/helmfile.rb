class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "152894fb2a75171316f8ebd2631a604a01a757d89e1ca7d0804126eed012a15d"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12e383c71384f5d73dc1072550844545b28b3d9abb276d8dabeb7a6eb13b51d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4602e0a9536c095f110fe84d141e0cf97135d4a6ee810c3f6c24ba01554d32cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9387b4d1c4bb6414be288f1574275396d74a810e9df16893afb370b82efd7249"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f046eb6597518a16c3070ff07d3026fe8422de97703dd7463d8b10ac2e058cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea49dc457e240af32d6d0a55570d992906aeacd8e30d09c3448011f0ae1be99d"
    sha256 cellar: :any,                 x86_64_linux:  "b6858636b42e70e1ffc08c962548d979d00567811fbceb2364800d8784ab2238"
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
