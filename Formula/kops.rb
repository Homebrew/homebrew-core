class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.13.2.tar.gz"
  sha256 "2e15d3f182b1a3651897240136fd36b55ec424f5285cd62587b0ba31d1adda7c"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f0641081d3febec6a563369f1d494774060511bdbf13e29378cd9a6bff6ce1a" => :mojave
    sha256 "4037cd237bec46b60813e84c1f11b6a46a8a7f62fae7634d0b5f910fc12e5f33" => :high_sierra
    sha256 "5d5681f56a4ecc56e221132e653d0266705c3a45cbe446f08c961ea881049b0d" => :sierra
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
