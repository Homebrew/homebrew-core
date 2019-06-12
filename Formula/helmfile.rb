class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.76.2.tar.gz"
  sha256 "0f93e89b7d9ec710e8625755696d42616ccde27365f54ea7ca029640c16a67c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "5577518d84e1945de5ab657287df5bf7bda5a1df1c0693ebb18f29fc15200134" => :mojave
    sha256 "38165182cdce1c57106314f769db8d6f4ee314e87560647a8049d70214ae1671" => :high_sierra
    sha256 "0e3dce57ecffeca93159ef3fd89814dafc15e0076b3715c20017a28e0386a5cd" => :sierra
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
