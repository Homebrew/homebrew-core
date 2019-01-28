class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.43.2.tar.gz"
  sha256 "b9ce3ce1e8bfa258004c9ddea21b3c9a27f27d40835517da3f716305e099401a"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc7316f6c406d9d119855e62083e8c4b6985834b3a64a22afac7b008ca53cd06" => :mojave
    sha256 "d521ac5e1a4d9c5ed012afc9cc9e64c9c5780a2b64f1fd55d308117f2e429a0d" => :high_sierra
    sha256 "4a410c2ed586ef605814786d38bbe215f23a381246679e47dd57a4d557ee446a" => :sierra
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
