class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.85.2.tar.gz"
  sha256 "059fe356c02b7e8e3bc3cca299ce521d1ca86f59965e98ca30c66a16e71c1494"

  bottle do
    cellar :any_skip_relocation
    sha256 "32343019472a9fe770d0d798180293e78baaa7ab394a7374a916aa1340c88b41" => :mojave
    sha256 "dd133b85bb00a02b7035d8f859e8348153231a812e0aa67d40d716a0654b6460" => :high_sierra
    sha256 "311c8dd661d3ed84484780a81edc9696e6f9fa43bc435beb124fe03002af8581" => :sierra
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
