class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.80.2.tar.gz"
  sha256 "522b71c4c12f802b8435beafddc3e8d2560d976a49b400eefba4804857e8647f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1492fddd1f18a4d6c42954822f55a668aed815e8adab1adcd00cf8cebefb3aa4" => :mojave
    sha256 "d96098c9145ba4b1939062189df9b0b0713c7b04b8d631f3c189842d165be681" => :high_sierra
    sha256 "ac959c0ed58e92087acf2a10758c9955de1ac6fadd884838a3ccbb57bc70738a" => :sierra
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
