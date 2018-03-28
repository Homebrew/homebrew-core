class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/ksonnet/kubecfg"
  url "https://github.com/ksonnet/kubecfg/archive/v0.7.2.tar.gz"
  sha256 "a01de014904af9177bb0ad15a249346d4b7bd6412268d0f83756541aa19fa38c"
  head "https://github.com/ksonnet/kubecfg.git"

  depends_on "go" => :build

  def install
    # Standard gopath shenanigans to keep "go build" happy:
    sources = buildpath.children - [buildpath/".brew_home"]
    ENV["GOPATH"] = buildpath
    srcdir = buildpath/"src/github.com/ksonnet/kubecfg"
    srcdir.mkpath
    mv sources, srcdir
    # The real build steps:
    cd srcdir do
      # v0.7.2 doesn't yet include kubecfg.jsonnet in the binary, so
      # let's add its location to the search path by default. This can
      # be removed when v0.7.3 is released.
      unless build.head?
        inreplace "cmd/root.go", "JPaths: searchPaths",
          "JPaths: append(searchPaths, \"#{share}/lib\")"
      end
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
  end

  def caveats; <<~EOS
    The template directory #{lib} is the default library search
    path. Set KUBECFG_JPATH in the environment to add to the search path.

    You can find more useful templates at:
      https://github.com/ksonnet/ksonnet-lib/releases
      https://github.com/bitnami/kube-manifests
    EOS
  end

  test do
    system "#{bin}/kubecfg", "show", "#{share}/lib/kubecfg_test.jsonnet"
  end
end
