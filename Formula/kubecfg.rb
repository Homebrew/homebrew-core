class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.17.0.tar.gz"
  sha256 "3e98d4d328b2265b4105c77fb83d2af78cec7e10adc8964b7fd45bade8dcdb7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e96db04eed01317519485910510ae25951343cb9274be6d25696fe9c343af9ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "3ca2a7964d6b069a284f85820cebc5b80f985fa3d8ca5f378339aa1d7fbba195"
    sha256 cellar: :any_skip_relocation, catalina:      "4115a6efb3f3509ca5acc8729e2714bb0c7f69f9e510fa26b5f379022d5b24ee"
    sha256 cellar: :any_skip_relocation, mojave:        "b58ddb11ca750a3edab428ef13766b9b94ed06c5dfcb1148006873977482d458"
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
