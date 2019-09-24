class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.13.0.tar.gz"
  sha256 "c971175bbb83bb39b0f35f0359103c43471c3b42c903990f52ea34fcb53dfccf"

  bottle do
    cellar :any_skip_relocation
    sha256 "97c9d72c446e068a87936c9386e3b86f6d114e28734e812ca6b688f24fc40f82" => :mojave
    sha256 "c19fe41ec12e33288288707e6d161b59e469dc476698c55f6d6e14b101c5c3b8" => :high_sierra
    sha256 "6724ef5826dddd49683b07e0bc10c59710f1758c024917259860b7f9b767f995" => :sierra
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
