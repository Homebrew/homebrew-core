class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.24.1.tar.gz"
  sha256 "4e5d01a92b04080cda5df729b21e54d44e5536904340301f183d65800eaf6818"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cea6f0bd94e973bea9120755ee7e943a63e8e8d18eec7fc02b86aa53d0ad3a00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd84c4e921d6e282f952045d25ecfe23de3d8c91ea1f6e33f47f0c710ed4b068"
    sha256 cellar: :any_skip_relocation, monterey:       "3acbb99c1e5e5a6b5110254dba1bfc635282d96cb7ec99f2d5b46e6c7f6e1753"
    sha256 cellar: :any_skip_relocation, big_sur:        "35a591b4e348eeadffd7f62a24cfa72215858e5405d40d6562bb17a51cb37620"
    sha256 cellar: :any_skip_relocation, catalina:       "e2ff8df6ffb8c5c3455f86a7140ac4a9cbfd284e0ce1bee81de876a3fbf01d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8cc147138e3c82603b3fae7b5282a9a5831f301066b939a0b579c96e60def40"
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
