class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.5.tar.gz"
  sha256 "f7c1dca76fab3580a9e47eb0617b5747d134fb432ee3c0a93623bd85d7aec1d1"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aee8751286305857c51d1635ffc75f220833603777122d71186a9ce65bfcb9f" => :el_capitan
    sha256 "588a1f3255532659f0cc5b01c1456d6022410f86b828121eaa4ded35abc9d372" => :yosemite
    sha256 "a60297807f4ec6bb884e610b2ca54d1c6d1dcffb52be461ae8bf815039b29e2c" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.4.0-alpha.0.tar.gz"
    sha256 "7530fabf418fccf7bef08281efa9a51d86921726c8efac4f0e63ba1e87d83482"
    version "1.4.0-alpha.0"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
    (bash_completion/"kubectl").write Utils.popen_read("#{bin}/kubectl completion bash")
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
