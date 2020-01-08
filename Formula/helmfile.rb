class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.98.2.tar.gz"
  sha256 "dad18c34a12124624f2c2bef3647f5c5d255abbf0e2741c8a2c05d70c587437c"

  bottle do
    cellar :any_skip_relocation
    sha256 "24e5e90710be49f15c492a37e1cb469d1cda071801c02edfb3919499844751f1" => :catalina
    sha256 "9d68eab249b5c67c07018c4c08d787823afc863842a0d21e62c1dd0c2ee7d14e" => :mojave
    sha256 "debd964a7bc57e35ae4847c86e7b24fa2699105737ca8d56874deeecd24241f8" => :high_sierra
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
