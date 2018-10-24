class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.40.1.tar.gz"
  sha256 "3194a334ebf1b887fd936d45b92b118391ca0552229680c00ec6f2fe37125106"

  bottle do
    cellar :any_skip_relocation
    sha256 "479480b3ccd169bddc68cec3cb5d2d143b5b76a692f4111dcda8945972d8a9bf" => :mojave
    sha256 "f6bbadcaf376d10d7d89dd187a87e092e3fe4a4773a8090fd017756c12bec521" => :high_sierra
    sha256 "0c7daa1ee05d76d1444cae10e1a851320408a443b9fffeeae0b5d7012b824bdd" => :sierra
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
