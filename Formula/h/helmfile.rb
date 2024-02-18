class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.161.0.tar.gz"
  sha256 "efe1bdfb2aeec8cb628eb582762dc3e59976eb44ffbf448924b84a87cdcd41c4"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "17d5257a623afb45086b972942e9b5633306f60d38016cbc23fa3e208f0c924d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cdbf4f5c95569ba277d35a7f93ee3e638589d69fcaf6808b13ea6f24af119cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1df10cc9ab767bb294e7afd2c93382d1071d5089ce85ebf621ab9dac7e3fbfb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d59631a570786319b2ab978d0f269cc2164dcc407f3e5b30037ef4a65de6b50"
    sha256 cellar: :any_skip_relocation, ventura:        "c5686951d643378f2de5d2ea0a5386e21e01e6699597d7db0ddd7502c5a34cd7"
    sha256 cellar: :any_skip_relocation, monterey:       "215149865288162be6ea8e1123053186867f316f89be905b447ca73cf4e66765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6953382e2a45919e96b6fefc351a38e33248aa98c81590b3bf86d3d1cc1c12f2"
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
