class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.15.3.tar.gz"
  sha256 "195ac29c2034291b4f04dff236fa0b1f4941e5f80bb95cd6c1caf9ba7c6305d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "6806b15bcf26a66a3ae92d719d6fcbec2f9f67abaf494327344c0514f82a09f4" => :catalina
    sha256 "5d237f809c3037311998881721649eec6fbde2f47466f4ac06abb21d9574bb51" => :mojave
    sha256 "c601859dc962325766348b6f52eb85da0edacf8d5299da7007d72ffd520ab31b" => :high_sierra
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
