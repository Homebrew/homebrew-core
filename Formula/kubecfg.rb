class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.16.0.tar.gz"
  sha256 "08846d19db0250a21d553cdaf1f0461dc398031b9ac76ccd360b169703f63567"

  bottle do
    cellar :any_skip_relocation
    sha256 "32946d46969da7c8e49e40cb3aaf149b74bb4ab1929f22135c7ca211c8b92e45" => :catalina
    sha256 "90e88901d99070b88824fed247438c712ecd941c2259e7b942e2bcc7910d78e1" => :mojave
    sha256 "db6f3ad9399f9fc978506f0966ea8f82f52da9879466412d2bcb2cc34d829a9c" => :high_sierra
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

    output = Utils.safe_popen_read("#{bin}/kubecfg completion --shell bash")
    (bash_completion/"kubecfg").write output
    output = Utils.safe_popen_read("#{bin}/kubecfg completion --shell zsh")
    (zsh_completion/"_kubecfg").write output
  end

  test do
    system bin/"kubecfg", "show", pkgshare/"kubecfg_test.jsonnet"
  end
end
