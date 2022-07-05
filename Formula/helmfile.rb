class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.145.1.tar.gz"
  sha256 "1df1a0b8ea5d4210bbf544a576d0ef924b32df8c3369dd8f0e66d5b395580278"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd7b64e0679ffb4a1c5e8c7b1221eb47a79342a271f202e9dd52e979266699fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "776d943ff4a4bcc3cdba67c49f8d7ae15e6916f122c1a9cca9cfe17155d6321f"
    sha256 cellar: :any_skip_relocation, monterey:       "d37ee13d50d558bd10f912fff326c78ea4cb1c86b098bd58f657e5d0b9638c9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a19b3227f720b457412ac265ec5f19411a0f82745d5b023965839b7a95faed6d"
    sha256 cellar: :any_skip_relocation, catalina:       "fbdaf5fae0b6b55a4377d60cd4fc608b84a533de8219f03b39492ded2c9c5aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "517b65334cffbb27057399fa425e8ff1ebeb5aa770c17592af70f53fc1616bab"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/helmfile/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/helmfile/helmfile"
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
