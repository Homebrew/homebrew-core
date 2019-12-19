class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.97.0.tar.gz"
  sha256 "34ebe9b78aa46b52a5efae612760c1b392f5ed241f2fe13edf6396ca021ce13f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fc8a5ca25194d860fd8c65afa2fbec4fdb01392ec710979823cf8b96fdb2174" => :catalina
    sha256 "bb0f97f7acba08e5009d0f37372a734fbccaeb9a50d86d17b40490ecc37fbe1f" => :mojave
    sha256 "f80cb36111b281164e4ff8dfd1cdad295e66fc42458c7245159226fc26c15392" => :high_sierra
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
