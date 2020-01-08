class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.98.1.tar.gz"
  sha256 "21b9626c9ddc2fbebb46d7b44cfb6be3f12314b5f7371bbfa44c9eea0af841a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "84cb3cff4e7c5a9d77385389f9b667aac5a05b006892358a3b29a5305af3fcc4" => :catalina
    sha256 "5846e17e3e8735d788d9414d6a13cf41f713cf9e1cf4db233530b1d3b88587fb" => :mojave
    sha256 "8f9e054f93b0da7f13ffa7b5b3d40ca4a50c3530433031bca3187443fc683a17" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: test
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
