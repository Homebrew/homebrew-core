class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.93.1.tar.gz"
  sha256 "86df2fde589d082786f73b6ac47852aa3ee918ead67d534659905f0c6dd2d54f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0fadc9634a628e4b52f4ad3068185a21fd123edbfb6e8359e4a584ae51e728f" => :catalina
    sha256 "436925a1545183bf77844a924052cda164c4bf7e8efd9df0b355475ce19a4be9" => :mojave
    sha256 "11dccf5a11946af1c24e5278d3100d1e338a038407f66cd643d5f4634df6beef" => :high_sierra
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
