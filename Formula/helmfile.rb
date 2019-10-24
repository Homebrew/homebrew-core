class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.87.1.tar.gz"
  sha256 "0eb3bec48f840dd94db75ce97a8541e0a73dc25073bdf3efcbe897d04984ad63"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9aabe9be927d946ba8594ce33548740e92699a8e55f8342a3cd1891a6bba747" => :catalina
    sha256 "0d25a35c891a56b005f55df05d12f7838c564fc470e80cd415ae8d538750f61b" => :mojave
    sha256 "c1302ce554046446516e700a541ed82b0e67af2d1dd4dd50eb2d282fd58cd5c8" => :high_sierra
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

    releases:
    - name: test
    EOS
    system Formula["kubernetes-helm"].opt_bin/"helm", "init", "--client-only"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
