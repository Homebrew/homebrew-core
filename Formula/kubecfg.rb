class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.24.1.tar.gz"
  sha256 "4e5d01a92b04080cda5df729b21e54d44e5536904340301f183d65800eaf6818"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36809c4e68be88403bdeb87f48db8d1ce5df6124680d93661017bc42a1f0d5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a3ffa549e43c5c1627cee4a31c2a370872c24ae88905349f3be1b39d752481"
    sha256 cellar: :any_skip_relocation, monterey:       "62e5ea9af0f539c88836fc9dd442bf4b93bbc286401d24e74e6d0d104705b896"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a0f57c70a3471df56b701ae4b819acf0804a5b76b8d6b32ba21cc163cacd683"
    sha256 cellar: :any_skip_relocation, catalina:       "7552c424643826d4ff34af252f185d9a131def789f74560f2a470fa44c964ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a87514db6c083d908ee63724f7c0f67191e5598f5f19e6c586dcb2e529447739"
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
