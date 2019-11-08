class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.14.1.tar.gz"
  sha256 "11672b169d833f0c8c5c43035f916a5b958e09ac2e000fd57be53ddadc37b38e"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a603d0c74e962ceda1e86988959731d467c5969e6863356e098c984ae68dbb71" => :catalina
    sha256 "4d9abd06ae2aad7b0770516121e5a8260d624a827b91789c648ab1b0a006f353" => :mojave
    sha256 "98e92a3e67632813390c346ef2cbc9917c58003ebd070a2852b8c84b1cb0f2ca" => :high_sierra
  end

  depends_on "go@1.12" => :build
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
