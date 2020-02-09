class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.15.1.tar.gz"
  sha256 "4446092e7717e9735e18eea5c8de552db7023a4bd4d035cc1c4229b4d16f44b3"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c96cb33a34b470798f575db1454c038f7c89b4238d0ed900f6f4622df84513ba" => :catalina
    sha256 "861d2041862915cd8cc2e6ee7104f0871c266a06837490179c3caa80b382eecc" => :mojave
    sha256 "4254fdcd2fd7057d653d91b6ff7b6724cd1a7385555c9acd5eeb7c843771ca84" => :high_sierra
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
