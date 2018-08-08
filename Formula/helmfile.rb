class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.21.0.tar.gz"
  sha256 "75503bd10fbff95fa5c4d84ef2aff8f62774eeec2d5a73d1025271883cd330f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "475db028fdce313b9546069929a092c5ad7c322ad4f1e067da6341c9bbf94b73" => :high_sierra
    sha256 "d294b4b24b638cbe8be50b74c13c71d214a8b57926b7dc042acc0793c1dee2ba" => :sierra
    sha256 "cb297ed4c9b8536ed35df937332b2cc826e3ff149102df36016f933ab7b13b37" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/roboll/helmfile").install buildpath.children
    cd "src/github.com/roboll/helmfile" do
      system "go", "build", "-ldflags", "-X main.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
      repositories:
      - name: stable
        url: https://kubernetes-charts.storage.googleapis.com/
    EOS
    system Formula["kubernetes-helm"].opt_bin/"helm", "init", "--client-only"
    output = '"stable" has been added to your repositories'
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos")
  end
end
