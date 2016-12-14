class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.5.1.tar.gz"
  sha256 "629f73b8519157e863df9cf2e724c188ceff842aeafa9953727460707f615d85"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "265f53a092c76c7c152cf342717acd321edec025671d42a4e6b7b5cae041d945" => :sierra
    sha256 "e713c07505de79e99442aa04a4e840a43f10917c995ad07d5c94e57d87ddd4f9" => :el_capitan
    sha256 "8e68994feec5640725662f217f8dce38bbaa5f7461c3ce923d9a8eaca4c4c216" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.2-beta.0.tar.gz"
    sha256 "03cba084d096c5898e1c72f359149dda74144bec4a8aeb672270cf1a2f976a0d"
    version "1.5.2-beta.0"
  end

  depends_on "go" => :build

  def install
    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl"

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
