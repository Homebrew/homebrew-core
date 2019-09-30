class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.85.3.tar.gz"
  sha256 "4805781eeaa30110d88769df04958de0534fa07444203d23476d68e15c916b7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a26f7da70b5ed055eab9e9e433cc6cc6163f161829cbe47190dbb037b98a249" => :catalina
    sha256 "ba3c80890ada183f48c8be694975ef1b3e1ce313ccb5a2ac597714ddffaeb8f5" => :mojave
    sha256 "4a16d37982580ecd1f4a4e6f46213144f612a38b0184cd3f2ae84992dd63d279" => :high_sierra
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
