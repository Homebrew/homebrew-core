class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.14.0.tar.gz"
  sha256 "6843d456871215d9426aea667178808a6749b329268e3c3385e7be8f5c8d9589"

  bottle do
    cellar :any_skip_relocation
    sha256 "2556f6cf6d6e24cb1f4fd3880d65cba6560eeefd08260b9a3fd19cf342abef69" => :catalina
    sha256 "97a6a726693bdb3bee47f9cc4c05f23818a11b7e9b8beb99a668b651bf033b57" => :mojave
    sha256 "600eaae96e6557e8c12df62ffee784635fc5def233e98ac6b850c4077473cfe2" => :high_sierra
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
