class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.138.2.tar.gz"
  sha256 "398de641d142e6d45153e3274bc6a96d240a343cdd71c6bf731605ac4feb338e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "099e60eba8d18b817e2e1aaa70968fafebaf08ae11160a0f2e7c273af9d560de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5375593c8345b38075fb95bddc83ad0da24e1cb33e0f6705cf907faf6545bb1"
    sha256 cellar: :any_skip_relocation, catalina: "8c97d52a8e9bd6ed6ef453497d75c0af00116191172a3e7285e262a00eaafcef"
    sha256 cellar: :any_skip_relocation, mojave: "7fee6ecd3c95262da06a0de19aaec4eaf286a8f8d8be182a6f2aaa2a98b266db"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
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
