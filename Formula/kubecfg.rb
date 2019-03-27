class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/ksonnet/kubecfg"
  url "https://github.com/ksonnet/kubecfg/archive/v0.9.1.tar.gz"
  sha256 "22255007b6b9fd7e30f0af0456ba49eb405e714b3236a88926c776716096f5ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "2156b04b138e78981c39071fe6e9153f0df6e7cca37a0a87394c4281d46ffa47" => :mojave
    sha256 "255c4945f34494eec08cda6c9ea748b30908c3660a3e79fd73d5aeca0ebc2082" => :high_sierra
    sha256 "81048ed4fe9c6b8f4daa327d03ca4e6ae2c51dee1dc1169f635feb48c29da49f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ksonnet/kubecfg").install buildpath.children

    cd "src/github.com/ksonnet/kubecfg" do
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
