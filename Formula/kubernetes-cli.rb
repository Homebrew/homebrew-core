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
    # building from the tag lets it pick up the correct version info
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.4.0-alpha.3",
        :revision => "b44b716965db2d54c8c7dfcdbcb1d54792ab8559"
    version "1.4.0-alpha.3"
  end

  depends_on "go" => :build

  def install
    if build.stable?
      system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"
    else
      # avoids needing to vendor github.com/jteeuwen/go-bindata
      rm "./test/e2e/framework/gobindata_util.go"

      ENV.deparallelize { system "make", "generated_files" }
      system "make", "kubectl", "GOFLAGS=-v"
    end
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
