class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.100.1.tar.gz"
  sha256 "25722bad9bc566541cc6afb6ac50bfaa3883c8354680e518c679219a174fbd8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bcc9c7292e2181b6bc727a8a6c7f1b06f859785a7d1c0805f353077dd72a4fe" => :catalina
    sha256 "687b9c529c6b79622ac0b6045bdf9831a4c8149c0e203d050ba66909857b5198" => :mojave
    sha256 "ff8f3ad74b1c7ed890456c0910f4da5febc56559e03942bcf25a84e33a660b5c" => :high_sierra
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
