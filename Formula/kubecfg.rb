class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.26.0.tar.gz"
  sha256 "322ed2b6d4214bafac63ee3d666aa240b077a0949d68bc97e5b6dfc484345b7e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d0493485d981eef070e9d601853aa14ebfa5aaeaadac1788220ce8e971ba6e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddf29077c8b978dabe38902a7989724a476bebadc7ac59006bdfc58a1a1103e9"
    sha256 cellar: :any_skip_relocation, monterey:       "a37780ae7c09e5c0509e947dfd371cefeb2ed3189ebe7bdeb2e53968dc3adfdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b809e1e16f28a716ef3508f803c5e585b6fad6237d20b8405b1cde5763691c71"
    sha256 cellar: :any_skip_relocation, catalina:       "a010bff9ce4cca2979d440abb3cf121f458c53f714470fbcd1cc8509dfe042d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e918cdb9471180fb31fe870940058ddd037ba7b9d9b391cf28b4f2f8d5fecd"
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
