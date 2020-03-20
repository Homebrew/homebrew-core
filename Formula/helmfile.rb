class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.104.0.tar.gz"
  sha256 "3f59cad242a65782afe6b7c95e23a8ae62cc2b9c96240151fcb9094e2f128877"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c22225960dcbb189b4c48b60c20e3a2aaabf44b52620b8f501fc1a1772b9a76" => :catalina
    sha256 "1341e0c4520da4e3aee1424d2fbe3edcc2b15508dd46fa22b3e797a7166c15f4" => :mojave
    sha256 "c9af6d43174024fe8ae0d3c1d566acf23c62e489e52dacfc88b06c158651c1e8" => :high_sierra
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
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
