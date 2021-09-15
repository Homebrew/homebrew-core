class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.20.0.tar.gz"
  sha256 "9085af1ce937d2535a699719c941b7678ae180a6adce9e8f490357d6901cd5b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a03d07c984d4997badcbc1853baa4fd86c86af02dc9209d02ae9b17cc55a9291"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6e870ecc92677c0994af7e9ea755deedbdd6c0432be82bd3093f4a71cb09eab"
    sha256 cellar: :any_skip_relocation, catalina:      "9e3d569d70eead295185ca587d0c4252ccfab6755ba55c7197524b0505d7e67c"
    sha256 cellar: :any_skip_relocation, mojave:        "3c364b5229c2f67ec49e1e31963394b50cad213bc429028501a9c8dd6c1d2578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d88890aca60bc952255a3c7eacf54af5a0e5390d4f110a5e06c22efe00f57ad8"
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
