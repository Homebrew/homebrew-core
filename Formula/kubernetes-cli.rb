class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.7.tar.gz"
  sha256 "40a655b5ae1734acfda157088a20853aaf87945508edf73497bec5fa26352a9b"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b75df19f053f15406f9bf62710af5ea431cdaadcbd89f8007d53332b5e45d5d1" => :sierra
    sha256 "be187031e42e63be7426f7e407bfabeec89c86cbbb452086130696529e6b9486" => :el_capitan
    sha256 "c718526ed5978f14c6fb7c0a5928f8eed73823545830d3e0457100a1ec84b4cb" => :yosemite
    sha256 "5ac3302edc31a3dae7e05fea8d75d911e99f40c4651621b00b48282f7b62c221" => :mavericks
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
