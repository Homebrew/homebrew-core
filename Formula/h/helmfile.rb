class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.167.1.tar.gz"
  sha256 "f14b88798ac83502d7c5984b510120172d19e767588093f23f9071c912a15829"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "411a724d4d381d1217eb6658c8ee44e4c9f4d10a90b9fe343f020ddb2e9e5125"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c0655c3063d0bad38b5b915d96dd2fabca84de3d2a4a5d7beca1e87fb2ed03a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d28dad0d9cc2ea2a240aa8d0d367d5fba16bd2cc8c1d27c848d043076d18ceb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2f591e30d7af959882890a6514d7104d6cceb1bf530194913df89bd1f4a0a15"
    sha256 cellar: :any_skip_relocation, ventura:        "6036c65d93b3c3b53abd886729165e3244ec3c8fbfa7951309dd28c8e7c9e812"
    sha256 cellar: :any_skip_relocation, monterey:       "b867bb4c3ea894c8c20422287355ba3810d331b705375260c61b7dfa953847e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87727ab0cd3aa9beb72fbf781a6da4f8d2a5782a5acf39c312dae5ee8135e33"
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
