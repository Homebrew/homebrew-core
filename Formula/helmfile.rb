class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.79.1.tar.gz"
  sha256 "93fbd9bab028e647b5664708923357571867862b9ab09b3bc730ac3bed14f749"

  bottle do
    cellar :any_skip_relocation
    sha256 "33b0fde8e74886cd513a0172111020e1a9af9c53c53d34b8487827f5cf089e68" => :mojave
    sha256 "6c52bcefacdd30f2ff846612336ade84bf3d71579012c7d0be4f991dead1eae8" => :high_sierra
    sha256 "0809588e4c209b83ae4e8bf0948dca3676bbde1a07fbff8bf3ffc3db064145bf" => :sierra
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
