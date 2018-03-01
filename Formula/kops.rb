class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.8.1.tar.gz"
  sha256 "e7dcaa8f50a51f878ed9a6478cba0c7b42aa34d33a1c9a7e6964fe4193aa51ca"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3972744739ea91ad25f852f5340658d07ee9ce505b0f786e76078bd2f35680b" => :high_sierra
    sha256 "15469dac5da51734d326d755d49120ce2b2b22c19bfbfebc1f348ce9e47470b4" => :sierra
    sha256 "19edd7d18f20a27927b3a889c263a3b1f2a898e91349ced6e95420cee6081445" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.9.0-alpha.1.tar.gz"
    sha256 "d174c32c4a059a9d267baa73bee31b7e291f65ea8a37b30fb3e5919cfa4c8f10"
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
