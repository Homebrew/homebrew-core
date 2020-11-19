class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.135.0.tar.gz"
  sha256 "c704aef4347b2a735ec9ebc2757ce875e1c8feca0a45b5ab4a30d279bd69443b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3043e37635c74d8d12695f3ea75c20b12303b1ea33d45e7bc22bd4d5d771f2a8" => :big_sur
    sha256 "4b978e72105ac51ecdbd93b8d92c104f64d50851852579ce375b9a89850ac40e" => :catalina
    sha256 "8287c467a778118920057138c2c53cf03b8de9cb5a86a4de434628fc0a167855" => :mojave
    sha256 "3be9d403a643bdeafb795a7f6ff8a9e85e38732d21edddb0a6d91321727c5de6" => :high_sierra
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
