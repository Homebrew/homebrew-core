class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.150.0.tar.gz"
  sha256 "463bb89470e2f714b3bb62ce2c8c96057f246fc874859d7570e9e9b616f0d94f"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbaa11be560bc3ab9f047239ba04f03513274e37ba2876319fd50937e1493425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04eae4c543cc72c4f72508e75e3ba3630fbc678490996c13b76b3ec4294b4d5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d055c30289a27d310e07d460143597c3282c9cb61b59a88297069c69f3d643f"
    sha256 cellar: :any_skip_relocation, ventura:        "eee80b6dde10def00fabf418d57c7d08289fa1ed288d796fbe86c4d45997f584"
    sha256 cellar: :any_skip_relocation, monterey:       "171e28c3808814f868b2718dd638620feb0aec766286c51d00c7d0e130a5d8c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "30bdadceb6e79a3432db9eab1dd0da763cd433b620e09bea42cca3663e3dbec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a767a6c677d9c45fb5bdde14a31547d578dea7387c6d73fcd23f3edbbdbcddc"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"helmfile", "completion")
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://charts.helm.sh/stable

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      createNamespace: true                  # helm 3.2+ automatically create release namespace (default true)
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: stable/vault                    # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
