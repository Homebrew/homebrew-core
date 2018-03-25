class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/ksonnet/kubecfg"
  url "https://github.com/ksonnet/kubecfg/archive/v0.7.2.tar.gz"
  sha256 "a01de014904af9177bb0ad15a249346d4b7bd6412268d0f83756541aa19fa38c"
  head "https://github.com/ksonnet/kubecfg.git"

  depends_on "go" => :build
  depends_on "go-bindata" => :build if build.head?

  def install
    # Standard gopath shenanigans to keep "go build" happy:
    sources = buildpath.children - [buildpath/".brew_home"]
    ENV["GOPATH"] = buildpath
    srcdir = buildpath/"src/github.com/ksonnet/kubecfg"
    srcdir.mkpath
    mv sources, srcdir
    # The real build steps:
    cd srcdir do
      args = []
      args.push("VERSION=#{version}") unless build.head?
      system "make", "generate", *args if build.head?
      system "make", *args
      system "make", "test", *args if build.head?
    end
    # The install steps:
    bin.install srcdir/"kubecfg"
    sharelib = share/"lib"
    sharelib.mkpath
    sharelib.install srcdir/"lib/kubecfg.libsonnet"
    sharelib.install srcdir/"lib/kubecfg_test.jsonnet"
  end

  def caveats; <<~EOS
    The builtin template "kubecfg.libsonnet" is installed for reference at:
      #{lib}/kubecfg.libsonnet
    but changing that file won't affect the compiled-in template.

    You can find more useful templates at:
      https://github.com/ksonnet/ksonnet-lib/releases
      https://github.com/bitnami/kube-manifests
    EOS
  end

  test do
    system "#{bin}/kubecfg", "show", "#{share}/lib/kubecfg_test.jsonnet"
  end
end
