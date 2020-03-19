class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.15.3.tar.gz"
  sha256 "195ac29c2034291b4f04dff236fa0b1f4941e5f80bb95cd6c1caf9ba7c6305d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce5beea0172c966ce164969307dd0788daad3b63688bcfb5e86f3c75c813f275" => :catalina
    sha256 "5e8181138be5fddf31ccd43da90ae2c21f22fde9fd440d85c028ac296b6760ae" => :mojave
    sha256 "56bf7821d1f3c63d9fb4c07a3052594d77d3c03dc4942414bdde7397dbeea5a9" => :high_sierra
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
