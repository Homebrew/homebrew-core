class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.81.0.tar.gz"
  sha256 "6aba51fed66930fe7445570116daa9cdd7fb3a0fa73b4758f490efc6561e8e07"

  bottle do
    cellar :any_skip_relocation
    sha256 "c07835bf5c7f685366c36416a10fae8b1925bc981baf106ef68d5eceb9d7df3d" => :mojave
    sha256 "17505b135bbc1b03d2f0920a1769360560791cdbb546f96ae74928c0da628c49" => :high_sierra
    sha256 "3abf9039c9660f44f6ff89c007ecaa3841444434284903819681f2262b57d248" => :sierra
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
