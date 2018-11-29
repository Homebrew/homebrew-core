class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.40.3.tar.gz"
  sha256 "cc34fc78734f7ad4222d4f411be784e4a04ad8ee3f17657243603b63aef327cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "d288ce573de492a93b6f56dfd3eaca2206de2754410437027bec2576a0f972cb" => :mojave
    sha256 "9c77e072e0725389d25a7d79d8fb8d97c7d9b3e68cfe0be5ad473596f05cefcd" => :high_sierra
    sha256 "35dcb001d546a89df875cc0f40e65f13dbe43a363296ef05b74abb31eabc9e8c" => :sierra
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
    output = '"stable" has been added to your repositories'
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos")
  end
end
