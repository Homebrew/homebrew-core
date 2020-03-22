class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.104.0.tar.gz"
  sha256 "3f59cad242a65782afe6b7c95e23a8ae62cc2b9c96240151fcb9094e2f128877"

  bottle do
    cellar :any_skip_relocation
    sha256 "066c5b8abf1b4a20c00c9499726f1960520da4d1a89c9a3010dc739de8ab08ca" => :catalina
    sha256 "337b3e6215fb9f8027da9de3b7f9710d3e6ffebfefd2dc17e7dc37d0b3d3bae5" => :mojave
    sha256 "e1cac5e36e8d6d8951bee0fe26e7a45e6edfc3d64d994bc097812c8ec934af85" => :high_sierra
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
