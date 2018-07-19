class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/ksonnet/kubecfg"
  url "https://github.com/ksonnet/kubecfg/archive/v0.9.0.tar.gz"
  sha256 "f7be1abb89ac830d3cd7cfb33e1ac1f861ba25133a2c66e597953dd7a20d1b77"

  bottle do
    cellar :any_skip_relocation
    sha256 "07038b5b21624e89b7e10c99869420154e5d733b7e7197fd5e44f4aa754b4564" => :high_sierra
    sha256 "168740e3c8d3542bacbae5b6407854f3425c612b6708b978fe607aaf82faad8b" => :sierra
    sha256 "38fbc753fd92ef4865ca29d9ad319f5815f4054b83f636af39dfc0813b5b7fed" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ksonnet/kubecfg").install buildpath.children

    cd "src/github.com/ksonnet/kubecfg" do
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
