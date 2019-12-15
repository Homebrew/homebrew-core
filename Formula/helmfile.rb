class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.95.0.tar.gz"
  sha256 "abc60798f77979541229237f26ecdc67ac5abe462a3ead69047fc19b72f27931"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed1284e0b701cf117d2e74a45b9bfd28664e4833a6090c00a4b9b3b16f36bd1b" => :catalina
    sha256 "49f98c9a8b8c985d95d35642af409ca799bbddd2e50c16ed0ab0df25dcafc716" => :mojave
    sha256 "567aef5106543fca1b91421fbf7bf4b0059566d582a0ea0264005d9be9cea527" => :high_sierra
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
