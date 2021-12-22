class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.24.0.tar.gz"
  sha256 "f75c9e0ca1523be10fa7968d64cacde2002ecd51b82df6724671ef2556aaa926"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bafc830bc631ee2d360d7e3251f69c08ccf01b582700dcb4eb50b32f3f910d15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bd966ee255a12461e4556efa500978bf4c7e2ed4993b70b32edd1f89e48c284"
    sha256 cellar: :any_skip_relocation, monterey:       "60fe82bf42f4089c5a677cb5396c9420390414e914e0413bf4f04a2bd6597a05"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffa4a693f3243e028b5244e84c56572da9a670e9f33a8613637c1d17c139a9c9"
    sha256 cellar: :any_skip_relocation, catalina:       "d2ad8917d09ff7312a4b78537fbe575921a9f496dbce30283e81e0d7bae2c23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8ec0e8ed59211283fe235c3128153c31819d0453a0c59cc6dc8197b0113f43d"
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
