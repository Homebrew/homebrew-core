class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.5.1",
      :revision => "82450d03cb057bab0950214ef122b67c83fb11df"
  revision 1
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
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
