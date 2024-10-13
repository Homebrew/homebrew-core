class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.168.0.tar.gz"
  sha256 "6b5efb52a5246b1c1d740d979a5e90f7219a987b7f4e1fd5d09a3c6846b5489b"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "61aec8dbf320e3778b115037d70fd4c61c6fc06897343f205f4a5816d9532f57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b358c36232e0c3c47241110b5e72e8445808194299b6cf27866fbb0f72049939"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8d53c801422f6216d8f1aedf2ec4c0682b5f6272f21f3dccc43805b2d90b8a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469b5b6ec8de34af8aa9c64eec5d7d149b9e1cc67e7f3ac58301bce582e67496"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ae0b2a16939a39842233fa8f274497ccabeafaa39a26afa3601d706df7d3024"
    sha256 cellar: :any_skip_relocation, ventura:        "f7e0fa46454973dae5075b509cefff84e290fdc7ccfa1315d465a0d77b338f54"
    sha256 cellar: :any_skip_relocation, monterey:       "121cf83efcf48be4c137d6e1f8212957fef8022eb5dcaf13d703bafbac9208fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5811e9ed09aa489867688bb47eefabd024d4b8de1096477e98fee55d81495e99"
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
