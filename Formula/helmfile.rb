class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.92.0.tar.gz"
  sha256 "fe2ec6b7b487bcba3b28108015c2ab223e233c789ee029b50e08e0bbd87c48c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f576ce215811b4a2008bb88f8396c617dc5e32422f2ea9bb8fca6009cdd4a01f" => :catalina
    sha256 "c35c76ddf6087f248d7f5c3da751e1e04d8810d3298ead04a7b35bd500e63af2" => :mojave
    sha256 "0e48282cad50d9674270009c6ad70c97ee6e82fe74f96a6ed98b901cb3a4847e" => :high_sierra
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
