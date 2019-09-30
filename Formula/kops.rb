class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.13.2.tar.gz"
  sha256 "2e15d3f182b1a3651897240136fd36b55ec424f5285cd62587b0ba31d1adda7c"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e23f8c08e8f15d5afdf58f85d543793ea1170daee1736b48e593665c2e73a4d" => :catalina
    sha256 "da468182ce6f4b0acc120dd38135e2958844dbf7ba745badbb361a55fb26d399" => :mojave
    sha256 "4ef87c718100f66b224e260278f3b13b287fa693dcd75726c9cac4e69d88f1f9" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")

    # Install bash completion
    output = Utils.popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
