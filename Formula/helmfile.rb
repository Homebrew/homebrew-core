class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.92.1.tar.gz"
  sha256 "dcb08533087aea527f581910c29e200a114556b462b53f34d92c7e75e97d73f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a945f0230bec22139c95c4c9eff26f470b26e1ecafc331572bf9aeca355c869" => :catalina
    sha256 "22a634444c7bf57c86185e6cb35ea37937e27e03ccd1c084b5fbd573e4739d4c" => :mojave
    sha256 "e517c4b8f28d9cd3111c88ed7b7e94ee39e0e567fcfdbf7d602a79ed9a35cabc" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X main.Version=v#{version}",
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
