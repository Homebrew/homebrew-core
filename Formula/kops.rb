class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.7.1.tar.gz"
  sha256 "044c5c7a737ed3acf53517e64bb27d3da8f7517d2914df89efeeaf84bc8a722a"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6a027731d8100218a3527395037d27f975b34cde7fe9759f9c1160e71bec2357" => :high_sierra
    sha256 "c3033753fbc5ce230279dd08982db353cb50b5338a7e34e2ccc389ab1acc9c07" => :sierra
    sha256 "189a6f76f16e9df99d24a86803dfde236cd1408ad1567c7e80b565babce8a707" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.8.0-beta.2.tar.gz"
    sha256 "f82a3fd9672a839b3991b7109a0d2fc5e73491e104c5afcb0168e65d20cffcd9"
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
