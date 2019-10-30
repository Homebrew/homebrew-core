class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.90.1.tar.gz"
  sha256 "781b53eec72856cb94f14b015ad6b565170f9b77c4e1823b1ded645e48ea1538"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffa72f0201a534ec09e8679d4d0a6bef2aaad2e3a480b3eda4d258649141f0c9" => :catalina
    sha256 "420d0e8cac89402c617ffb45287c0fce249074397c52c7cd10ab2536cec49cda" => :mojave
    sha256 "d295ce44e0fb63badd469aba57c49a2e1f1fcb5a085cbbc807baebdfe9317b79" => :high_sierra
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
