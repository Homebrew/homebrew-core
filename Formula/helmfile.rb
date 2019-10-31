class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.90.2.tar.gz"
  sha256 "52cbcdbf08f3a9f2322e79fb9f799d3ba10ac2817db408ba4afc024762a41296"

  bottle do
    cellar :any_skip_relocation
    sha256 "c153e7a7fb8201af4760cfefad98a17c656c1e99375083963245c6da2c0c94a2" => :catalina
    sha256 "c8e223a5ca8af3a0d8dec4ca589bd283ec5a5c0f9be4a97d2f9920340e7db0e7" => :mojave
    sha256 "dac7775b58f3697879eea0043433879f5f5123a7ae95979e6000a9c9989bf742" => :high_sierra
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
