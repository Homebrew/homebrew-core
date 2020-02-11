class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.15.1.tar.gz"
  sha256 "5b997e0d67364a81f377effc5c05dc74453ab87ca9299e8ca5de9caec8719261"

  bottle do
    cellar :any_skip_relocation
    sha256 "a30297ba6bc068055f803d06ac74d008ca5b5f8011d9ee153df531f9cd3d38f1" => :catalina
    sha256 "945b67fb4fa66d374a644b02463ddd2eca86ee16cd3adfca27b2d720e9c0415f" => :mojave
    sha256 "c8cf438c0380015e59bda5b71ab99a2a6fac88bbb114d07735a92cb7f946ba0b" => :high_sierra
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
