class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "5b304ff8168d33bb41f75495f172ced7118dc7b35f43d56a024652e4e724d1df"
  license "MIT"
  version_scheme 1
  head "https://github.com/helmfile/helmfile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "248d559c55749a60c39121e7bfbac432655e4dbf84132a9b302a8dac110d53ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a2abd2d962cc845394fbfce773a00cfb6a7850fad7da0bd953fe6ef5fb006ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aedf8bfb589a384be063d581a7764a9c8b0a7b78612b9035055327edcaf624d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1619e096c1acb2abcea96035f17ac0aa2f03aba9636e07320d7232968c5b5c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673218d8e070c0322022ccabf5ccc2cbbf101af242d9907b7635b48c9a669e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb7d23e01aac99ef9e6f000a6e12f39a56204fa2b7dd591455b6dcf2a51c923"
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
