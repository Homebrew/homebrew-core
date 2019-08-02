class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.12.4.tar.gz"
  sha256 "0d38cecc0e1737d2d27c0ce31e1d36b3c5cdc19f4c2ab77d254229ab9685d915"

  bottle do
    cellar :any_skip_relocation
    sha256 "80246b85adeb76d233ad84a6c8097bf23670aa058871aafd5e64b83da0b5fd08" => :mojave
    sha256 "8e3046f1ad845339a61a232e0d6b0a13aeaaaf1ba3d7d2280791aa703dde4994" => :high_sierra
    sha256 "3b20d5ee37cc4d4f78679c3a0eb4d4cfa8ee48efcb10600b263bca39356a6e4a" => :sierra
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
