class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.16.0.tar.gz"
  sha256 "08846d19db0250a21d553cdaf1f0461dc398031b9ac76ccd360b169703f63567"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4b1c21dd475b3d66051e4413173991f7825876fa09f82b0e0b913c2355ad3de1" => :catalina
    sha256 "18a96eba78f47594337dc07a87ba17c90c3562eb665e5318bdc660b7556f1bf6" => :mojave
    sha256 "1a504128fd97438fc4e35ef265bbc2b7693ddd11dc343c0a6b1dca55df593ab3" => :high_sierra
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

    output = Utils.safe_popen_read("#{bin}/kubecfg", "completion", "--shell", "bash")
    (bash_completion/"kubecfg").write output
    output = Utils.safe_popen_read("#{bin}/kubecfg", "completion", "--shell", "zsh")
    (zsh_completion/"_kubecfg").write output
  end

  test do
    system bin/"kubecfg", "show", pkgshare/"kubecfg_test.jsonnet"
  end
end
