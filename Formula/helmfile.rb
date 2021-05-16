class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.6.tar.gz"
  sha256 "630500b3b2d58217eb78ddcb4f7478b43348b2fe29752c90f437068bb277c1a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20038583294284c6b13b5db6729abf9f08d069708af542cae614a58f7fd7c813"
    sha256 cellar: :any_skip_relocation, big_sur:       "2eb52b4b5eacbf381e1015fde3b781fe39be95555c7a9b07c08ae75b72eeda0b"
    sha256 cellar: :any_skip_relocation, catalina:      "bc8794db54441c81a332645f924a217275c551484ed5776f2e3cb0eb8aa053b4"
    sha256 cellar: :any_skip_relocation, mojave:        "78370ff1082e79f59965243f2ad3326c641198c20950d4705bddc377b30c2272"
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
