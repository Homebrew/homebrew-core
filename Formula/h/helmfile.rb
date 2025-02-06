class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/refs/tags/v0.170.1.tar.gz"
  sha256 "cb7480cbb6721c678093c03f3e62b8fb3291795a103489ede8dde16c55eb2836"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf82b8ab2c0f6e524f6d7a9c66b2edb631df3e04b7cab9ae35bda81806a5728c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6a7df24db2acc591891f30325e4fbeb255723677e02a2761b8dafb571b9fe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da80bfd8f52e2cca7b9ea4ca222419d5bbd7e60d876f9bb1c2ad483bff8c5aa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "306e9d1de6786a0130da4ca742b5094d8791f1de8e5c89a501c04bb08091eb49"
    sha256 cellar: :any_skip_relocation, ventura:       "a539d7373385bb1fa32f3bcaef3380ce2f25596c31eaaf1865461318b6a377c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "185d084d816644f2c1c2cbc3f187ff544ca40f88fac35434673a45570ab9196a"
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
