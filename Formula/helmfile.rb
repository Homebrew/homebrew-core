class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.81.3.tar.gz"
  sha256 "4c795428b226cd25c7c1b958580580ee5a8deaabe4b4d0d2aee72d26204f570a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffc9d42c4e2411ca21eda97250152813f1bdb974a6575017ab5aea2209c1a772" => :mojave
    sha256 "ca203349807e0499a9f06956d61b3f767069541902fad49c58b690a0c6a6d79c" => :high_sierra
    sha256 "2a29c25b005b21175ceeecee6c25c4fe3456ea07443d653acb789ea07910f8ee" => :sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-helm"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

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
