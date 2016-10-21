class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.4.4.tar.gz"
  sha256 "ab6304dbff6e49095d68459da748477ffba231893e1f1dae4e0d60ba2fdb725a"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bc0d1841ae9aa376dfb866a1ea9ad97517f3263c6d170cb20759e79ab19608c" => :sierra
    sha256 "bd6a762cd9e4f7d999f86c9470227611aa6e13a0da3db97a9117c16b74d49938" => :el_capitan
    sha256 "dccdacf5c86d6d95d0028b62db543dd6ec286c2d02b6791fce665cb7bf7d0b26" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.0-alpha.1.tar.gz"
    sha256 "4b05aa319c394e085c219ab8f7b2170ee137da2f726da51d8acda450e67ceb00"
    version "1.5.0-alpha.1"
  end

  depends_on "go" => :build

  def install
    # Patch needed to avoid vendor dependency on github.com/jteeuwen/go-bindata
    # Build will otherwise fail with missing dep
    # Raised in https://github.com/kubernetes/kubernetes/issues/34067
    rm "./test/e2e/framework/gobindata_util.go"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl", "GOFLAGS=-v"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
