class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.23.1.tar.gz"
  sha256 "bc6fd525285db0089124935a4159b3c78ad194e7295bc3ef73cca595a30bd059"

  bottle do
    cellar :any_skip_relocation
    sha256 "827d6da46510cff48338388355af74ac5f65544e7f088ca8e4140fbb779b1e07" => :mojave
    sha256 "2e116853a431ea48a1aef3afd150681134b91db5f7297281d54ad98622e5b8fc" => :high_sierra
    sha256 "3864e2573e74be79746352ddba55b3c477c01e8bf76c06649d811fb502ae2038" => :sierra
    sha256 "e8d184fe7227637424e36185e21c5584b330d477db92a1f2e697c54a650c5c69" => :el_capitan
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
