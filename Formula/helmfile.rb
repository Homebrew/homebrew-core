class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.81.0.tar.gz"
  sha256 "6aba51fed66930fe7445570116daa9cdd7fb3a0fa73b4758f490efc6561e8e07"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a8d87604dd96f89798ec61f0fa41f2a2d400d2ad9fe36d012eba2b4162c151c" => :mojave
    sha256 "aa34b8a58a9f152677b303937e99c01d794dd6bdf2530fca71eb8194568f75ba" => :high_sierra
    sha256 "ff806924398e6caee42663e2a6cd6cf8c9e636381ae274b9f4b295a2e3d972cb" => :sierra
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
