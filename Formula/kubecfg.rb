class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.12.2.tar.gz"
  sha256 "850c206fdbd585ae43f5fbf59d6328448bd49bffc6868255e7598b8a09ab4254"

  bottle do
    cellar :any_skip_relocation
    sha256 "84bed4c9638a762c15b0bf5a9709c49a9f89acf81dd57710832ae41c83c44253" => :mojave
    sha256 "56b59e971880081f820355b3661a32058f584d54cd0044b686724c5ca2c56e43" => :high_sierra
    sha256 "646b089ef7e817b954d541ea65c7226a2be3a2e9d55678e49ac30575b9eaa314" => :sierra
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
