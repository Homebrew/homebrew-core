class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.17.0.tar.gz"
  sha256 "2295ab02656a7b16a4b01cca0dd248ac5fe33b5bb18bae3b81232aac0b841812"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b9467ee7e24af7d19824169821fceaa4a1ffcb5332d26ffd9f4d48297f421c4" => :catalina
    sha256 "b6eac0a871fc5d0146a589adbbacc1ff7c96fe526ad4a740c5057d86f6f7a2e7" => :mojave
    sha256 "01ffb437bcabd478faefdce5bf0aebcb2df4e12e88ca125e139a5fd32361114c" => :high_sierra
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
    output = Utils.safe_popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
