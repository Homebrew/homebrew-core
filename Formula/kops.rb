class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.17.1.tar.gz"
  sha256 "880414505447ae8ff4b91ea5c75e5de1a532a66f113e51db15b83672c8cb78d2"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d0383ddcb2f85780a0be412d6dd3fcfd9bc33655dc371b500ef6bf2267fcdf8" => :catalina
    sha256 "d8c1de857e2c053e4091042949b0a09ecb1c69f6a085884fac29861489a11ed1" => :mojave
    sha256 "921c6742f69758f41d1decff640dc1fa42237f0056c5d3c905a5194d8f5b7b33" => :high_sierra
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
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
