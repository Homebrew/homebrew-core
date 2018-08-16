class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.10.0.tar.gz"
  sha256 "08f6ddf64e9003f12df8a33afe077418994aff40ab0b655b2fe162c63cfc7190"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33718a0de46466c723bff46fd2438e22725c665356ce744e708ba335824448ac" => :high_sierra
    sha256 "c35afefb009719db001ed79ae61d5cab73f34d9304f20194790ba4af8b4bee56" => :sierra
    sha256 "dd5f4e934ac582b7f4159c0541e2fc51f5ee075043547d8e54e28c2b63b501fd" => :el_capitan
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
