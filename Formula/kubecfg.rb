class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.11.0.tar.gz"
  sha256 "79dcd7e680e2bba156e48ef7ecfa47b151560265b7bac9fdbe7bf193cddf3c28"

  bottle do
    cellar :any_skip_relocation
    sha256 "490d2ab5fabe07db8b701078765a619a111917b0c798587d6bf9163fc2c9ad3e" => :mojave
    sha256 "ca477183a60bbe70b45dad3513a4a1e2b013df064a83413e787019660cc16d3e" => :high_sierra
    sha256 "3ff281f3c0497306e94fe92ab027f0ae60bedadc134da39b9b1209588387b948" => :sierra
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
