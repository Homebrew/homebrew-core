class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.0.tar.gz"
  sha256 "77fbc5db607daa723e7b6576644d25e98924439954523808cf7ad2c992566398"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43c56949efa157d52d661fe58274fb9dd424a16d9afba18164268349bc2630ce" => :el_capitan
    sha256 "1e1bbc70659eb347b15d40d820c558b6a394dd42de808a3ae385f2a49b5bcf3d" => :yosemite
    sha256 "494f9a50ea488232072cd056cdaaaa0879bb1f604cba060e06207d7694b9cac4" => :mavericks
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
