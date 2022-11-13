class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.148.0.tar.gz"
  sha256 "d79b24bfd0876af083158a0f458a3588d06f2aee933377d4b1fe11ac61cfa80a"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1c4c43a44259edd68644c2ac040d26d5786b9990dd071c77375cdf7ea6fd3f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e8af2388857795807014a8fe62c10b67ad15474b8490b06acf0172d22ccb1f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "429954c65e971d18ac34ad9323dff74f962fc69dc9d2d5bff13354224be44686"
    sha256 cellar: :any_skip_relocation, monterey:       "25b9d4d5cd9bf26c72258971795dd3aa8492e204e904f1a82af2d557447c923e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1451029cd387ec093cb3dc6ece4a46fc9ad63f81a7e4f6a8b8a0e195321c1c53"
    sha256 cellar: :any_skip_relocation, catalina:       "7d457788b05c14cc87cd80c2015a37bb38f44e336d9e2f7d0cd3b0e7a379139b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f52a0790f9eeb54dcf8ef3a29c9379de8134443b9e858470b4399dcffcd9e411"
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
