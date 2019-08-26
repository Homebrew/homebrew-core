class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.12.5.tar.gz"
  sha256 "1bb06d4a0718ad87d151c6354ebcc75353a7c9e5d218db63e6b6503e0f617ecb"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1f62306480ef3b023302d5a913fb66e8bf7180d2c8767c3c129925f9a20a0c7" => :mojave
    sha256 "630126e1fe2f008e1d8608a741691e60f184caa0c9a28fa6f8da0e96f8720253" => :high_sierra
    sha256 "7d8fdbbd0a93bc3e96963dd3adc65b5de83adab6a6fd7152eeda943d49825a76" => :sierra
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/bitnami/kubecfg").install buildpath.children

    cd "src/github.com/bitnami/kubecfg" do
      system "make", "VERSION=v#{version}"
      bin.install "kubecfg"
      pkgshare.install Dir["examples/*"], "testdata/kubecfg_test.jsonnet"
      prefix.install_metafiles
    end

    output = Utils.popen_read("#{bin}/kubecfg completion --shell bash")
    (bash_completion/"kubecfg").write output
    output = Utils.popen_read("#{bin}/kubecfg completion --shell zsh")
    (zsh_completion/"_kubecfg").write output
  end

  test do
    system bin/"kubecfg", "show", pkgshare/"kubecfg_test.jsonnet"
  end
end
