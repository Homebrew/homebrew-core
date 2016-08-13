class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.3.4.tar.gz"
  sha256 "19b2ebbc3976bb97883dc40aaf14ded7863d4098922e99a1dad873d5435fe21e"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "83fbd8b8f73fa2935d580c38af0028d4ec765baa9580a0506fd0180691537e54" => :el_capitan
    sha256 "be7312f14a7193db29e51b3d053ca7499d4905aa6f6e69a56782ab976d835b56" => :yosemite
    sha256 "9d44dc86b807b24a5603be7bcbc6adb5b1a646d23cead03a887a3137c6970abf" => :mavericks
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
