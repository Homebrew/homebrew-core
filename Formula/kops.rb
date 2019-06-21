class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.12.2.tar.gz"
  sha256 "e453bfd39a8bd079a14cf8d8c1b22d1429ccd4f5701b55f3612528263aeb97e6"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "862c5f6648646840c75172e2f9f701cb590b04df03c38716b5ab0edc61625130" => :mojave
    sha256 "9e53f38c9dc376574797e1e7e5c015472385d1fccc31d5a1f5fa502ef8281593" => :high_sierra
    sha256 "dfbf818c1225b5ff9e92c6888d13a94dcee74a52680e496f5f4d5fe60552dbdd" => :sierra
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
