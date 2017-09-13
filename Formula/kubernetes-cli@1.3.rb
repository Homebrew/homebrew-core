class KubernetesCliAT13 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.10.tar.gz"
  sha256 "7167e8c8e68d34596018103b55724f01d9b5e1f715c816c347a967cb438d6d18"

  bottle do
    cellar :any_skip_relocation
    sha256 "90f6531017970c3adc25a33412ff5e6189b7e5c4fd7ed755ff254357984afee5" => :sierra
    sha256 "e12f80dd4ec73d313f474fc4f79a9619209e5d40656a7808c50846c1d169f564" => :el_capitan
    sha256 "490566a4266fb26ca84175197db2ec55fe3aac0e70e7334fccc9343d3d1556c5" => :yosemite
  end

  keg_only :versioned_formula

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
