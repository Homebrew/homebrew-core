class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.86.1.tar.gz"
  sha256 "09ca9a76ab1287a0bc905d5a6ef7170947a873ca5c111d94925931b983b4069a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d1d0f17ac37e69ce89feff27b4f6d7e672897cbbae19fbcbaff7dcb9813f437" => :catalina
    sha256 "bc12eafdff3392b99bd8b82c7536b59c33ff30ecbf38fb2c7c74a1ccaa2b5cfb" => :mojave
    sha256 "1021ec98d89659d9f1b8b1838fdaccdadb3e3e7db872cd2c48a7f905a9db08b3" => :high_sierra
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
