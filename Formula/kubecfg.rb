class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/bitnami/kubecfg"
  url "https://github.com/bitnami/kubecfg/archive/v0.12.5.tar.gz"
  sha256 "1bb06d4a0718ad87d151c6354ebcc75353a7c9e5d218db63e6b6503e0f617ecb"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7ab8d3c39f6c522643e64b88aa7db67141eff3de864035c7a84bc8a80cad495" => :mojave
    sha256 "dba37df5816c9638a811c7e31b3c6fc65ffe095b58510ed4dc6063124eac9f5e" => :high_sierra
    sha256 "96cafd3a7b7591b16d2927673dfa6107db2c1f38208cc946cc0d13b637c75cea" => :sierra
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
