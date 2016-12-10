class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.4.7.tar.gz"
  sha256 "2f5d4c5071109935386c550899ae85f338ee3a9d58cb1908d2d975d8a9c5baa9"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90caf18e13c8636d27b332cb8acbe0944bb8effba7561ff193df37da22580135" => :sierra
    sha256 "8aa4850f497674190d6d374853519c1629e0fb2466c5618b1473ba47d172b697" => :el_capitan
    sha256 "48e82ebddcbc0c4777469014f69a1cc98f7263105aa4b17bcfb752ab11d37690" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.0-beta.3.tar.gz"
    sha256 "210a84a0585160cf5947148f7b4c239a62c9b202e3cecbc7b87ef14a8c62042c"
    version "1.5.0-beta.3"
  end

  depends_on "go" => :build

  def install
    # Patch needed to avoid vendor dependency on github.com/jteeuwen/go-bindata
    # Build will otherwise fail with missing dep
    # Raised in https://github.com/kubernetes/kubernetes/issues/34067
    # Fix merged into 1.5 branch; patch may be removed when that goes GA
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
