class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.85.2.tar.gz"
  sha256 "059fe356c02b7e8e3bc3cca299ce521d1ca86f59965e98ca30c66a16e71c1494"

  bottle do
    cellar :any_skip_relocation
    sha256 "82ab926c6afcebf35e87115c17d84d291611d034634ad1248376aa50310dff10" => :mojave
    sha256 "e10785894404349597bb9131dc1f3b14aea7bad39e542eeb835a80915090ec40" => :high_sierra
    sha256 "61dd90fdac7fc1b2a12fd3e15cab0584ba337a0397e1d65f833894223c769a06" => :sierra
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
