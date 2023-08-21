class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.156.0.tar.gz"
  sha256 "8189bc46e885ba3acbe7f5ae58bf41114b48614d0841abb15acfef3dcb4fd654"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca18376c7fd85407717f4260b29ea6b03feaa3af7d74f35bf30de832d87cf376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49a6fe512116819050933a0466013acb28157e30917cdae908e2ef891f786703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f942b9b7b726000216b516ef0f18ff3b0c823614547014a123b47b179417b7c"
    sha256 cellar: :any_skip_relocation, ventura:        "0d2bb313328fbb5c1ef23064e431db15faf94fcf6b7bf52f5cdeaa0b5b67ddb9"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf1ae949dfcc40e9b701d9f6326643ee2860e0c270ac7868877c330b9dcd3dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f94de75ddc8b320a38a47dbe822110222511c7742604c911c64bae228fd47bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a62bb24f7defa2b37fecb629b6c89387462f5cff7e6f1243458007523d8dd85"
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
