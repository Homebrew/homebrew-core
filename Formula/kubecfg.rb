class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/ksonnet/kubecfg"
  url "https://github.com/ksonnet/kubecfg/archive/v0.8.0.tar.gz"
  sha256 "25d054af96a817bad0f33998895a9988c187e1399822c8220528e64f56ccb3ae"
  head "https://github.com/ksonnet/kubecfg.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    srcdir = buildpath/"src/github.com/ksonnet/kubecfg"
    srcdir.install buildpath.children - [buildpath/".brew_home"]
    # The real build steps:
    cd srcdir do
      args = []
      args.push("VERSION=v#{version}") unless build.head?
      system "make", *args
      system "make", "test", *args if build.head?
    end
    # The install steps:
    bin.install srcdir/"kubecfg"
    sharelib = share/"lib"
    sharelib.mkpath
    sharelib.install srcdir/"lib/kubecfg.libsonnet"
    sharelib.install srcdir/"lib/kubecfg_test.jsonnet"
    output = Utils.popen_read("#{bin}/kubecfg completion --shell bash")
    (bash_completion/"kubecfg").write output
    output = Utils.popen_read("#{bin}/kubecfg completion --shell zsh")
    (zsh_completion/"_kubecfg").write output
  end

  def caveats; <<~EOS
    The builtin template "kubecfg.libsonnet" is installed for reference at:
      #{lib}/kubecfg.libsonnet
    but changing that file won't affect the compiled-in template.
    Set KUBECFG_JPATH in the environment to add to the search path.

    You can find more useful templates at:
      https://github.com/ksonnet/ksonnet-lib/releases
      https://github.com/bitnami/kube-manifests
    EOS
  end

  test do
    system "#{bin}/kubecfg", "show", "#{share}/lib/kubecfg_test.jsonnet"
  end
end
