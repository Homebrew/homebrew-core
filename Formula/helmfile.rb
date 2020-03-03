class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.102.0.tar.gz"
  sha256 "7e9cb2023d1630903c65f8c5bd9b30e5f71299c0cb5d0f783917c46329ab4ca5"

  bottle do
    cellar :any_skip_relocation
    sha256 "6709a260fd7639eb62a31f62ed2a1b741c81639f18d04ac233dd46e05281964d" => :catalina
    sha256 "7e00ad411ab503306b2c3bb4c8d2939801ac2362b327758b8b78f365cb2c5060" => :mojave
    sha256 "7ca37d260083d38422d780e150f41d0cbcc01987bdedfb27dfcecdccf36c1650" => :high_sierra
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
