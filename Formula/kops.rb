class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.8.0.tar.gz"
  sha256 "dfab4c304247723d02cdabc83840ff0fbfd8ae4238d248839b06cd62f84400d7"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52a2190c78c564faa9092fbf1aacb4cd8c59b83cbf549e941105cbd49ff41c36" => :high_sierra
    sha256 "50405e6faf1a0b3b794c43b9be3d43b76721ae22ae7d0933a7d02cea22c1100d" => :sierra
    sha256 "3fb69de6b4a43d42e2a1811307c384d3ae823524b03a74fba414b24ab8ed3e42" => :el_capitan
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
