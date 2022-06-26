class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.26.0.tar.gz"
  sha256 "322ed2b6d4214bafac63ee3d666aa240b077a0949d68bc97e5b6dfc484345b7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9768b8d05bb597d10c17b651a2f53e359672bdff4c62d5f7014af0f9f179ed1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1e27b47349c5f79a07cd74caee23d669b62525e5c35f9eb753b94a5cc9999d2"
    sha256 cellar: :any_skip_relocation, monterey:       "a507a3f199887fe0cc53bf95abe8b9bae088884835a808396a095f3f10fc5b19"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fdd1ec9b49b9025110e2e7170ae17eaa748555b3aa2f4dc0d517bac414f4e37"
    sha256 cellar: :any_skip_relocation, catalina:       "bbebd74f09def44ea84f6f1d93379d9afe323fd68179796eba8039c646e0dbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5515ec29c682a2ce2920551134b1521327c769f88295fa7af57218c73df9c71"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/kubecfg/kubecfg").install buildpath.children

    cd "src/github.com/kubecfg/kubecfg" do
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
