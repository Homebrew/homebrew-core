class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.83.1.tar.gz"
  sha256 "c464aadac0df69dcb304847f469cd61b6dc29a40b7f72d2fd6b63e26ca9c29d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "de756acebafb2492185b8ca54a6b38bb38194e79751423662c77194d2d19d083" => :mojave
    sha256 "262185e3190c81470de80f79d3e6bbd94610196c8990f54aabc8df69a678b6ae" => :high_sierra
    sha256 "048e3a20a63c03545c0a822f9c0a1cacb97f1e23aecf15b396cbcfe0379eba9e" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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

    releases:
    - name: test
    EOS
    system Formula["kubernetes-helm"].opt_bin/"helm", "init", "--client-only"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
