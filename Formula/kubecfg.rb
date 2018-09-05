class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/ksonnet/kubecfg"
  url "https://github.com/ksonnet/kubecfg/archive/v0.9.0.tar.gz"
  sha256 "f7be1abb89ac830d3cd7cfb33e1ac1f861ba25133a2c66e597953dd7a20d1b77"

  bottle do
    cellar :any_skip_relocation
    sha256 "74b6a842325a2c17866bfe74c7183c34bddb53cfa0af4d56ea0bc972f4d8cfbe" => :mojave
    sha256 "c70bb19117bf8fc90b8d6ca73beb6606dc2be4078c48168d574358298e70f43a" => :high_sierra
    sha256 "04fc44f3869f25d396791233ffae3ae50a172adc4fc2ef4b70fe70931f54f454" => :sierra
    sha256 "b1e86a9bd8512770cf754280962870643d370f06e7eb962babbe15290bacb6e3" => :el_capitan
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
