class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.19.0.tar.gz"
  sha256 "b908c49e3f449b42b8107351ad9535ae47bc6f7b58c51b0a5e9c81ae7e3aaabe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "261b8676357b1492c50ed21b62bce7ba57eb845b634e8c0c296e66c7ff73e2bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "437a63b11e2781d08865dca5f78ea1eabab2b514b1c715eb206a4a0e9b418bd7"
    sha256 cellar: :any_skip_relocation, catalina:      "fdfcc51faa2ddaad019820b05cc23df77990358d2ff51a7407a8929cee001b04"
    sha256 cellar: :any_skip_relocation, mojave:        "f9f677e3d7904f705e34ef49ad30874b0a278ed6c7d88b134849bcd7840c7a98"
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
