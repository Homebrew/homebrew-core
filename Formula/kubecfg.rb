class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.15.2.tar.gz"
  sha256 "cac7693496308f450b1844fb3364b9d4fe507660d60735d23cbd31a415a3e83d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bea093469a9687aa36b4ca9ba45a3d40286d273298bf0ee7660116560611e904" => :catalina
    sha256 "f49971cd1bee7f4b229310e0e5ef684386eba22c5c6d821b278b63a1d9a5d8bb" => :mojave
    sha256 "ee98763636e2cef46ca15337216ef441d000057adafbd72667e0fde22d507be5" => :high_sierra
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
