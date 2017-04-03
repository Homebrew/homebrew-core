class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.6.1",
      :revision => "b0b7a323cc5a4a2019b2e9520c21c7830b7f708e"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec0fe7de3bb8def900e8f238a57f4645fc870b64e79346e0a3108e47bc01d701" => :sierra
    sha256 "558c06887bdcac310c5a18d2e1d0aed5152f35491984f50bba945e44fab0fa37" => :el_capitan
    sha256 "9bcfb52b91a113603851736d9a1924ae8ab11c17462e0b41499e593d79fea7cf" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.6.2-beta.0",
        :revision => "aaf9ea07f519a2c3f4769dc8d10b807ad1a8d279"
    version "1.6.2-beta.0"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    dir = buildpath/"src/k8s.io/kubernetes"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Race condition still exists in OSX Yosemite
      # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
      ENV.deparallelize { system "make", "generated_files" }

      # Make binary
      system "make", "kubectl"
      bin.install "_output/local/bin/darwin/#{arch}/kubectl"

      # Install bash completion
      output = Utils.popen_read("#{bin}/kubectl completion bash")
      (bash_completion/"kubectl").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/kubectl completion zsh")
      (zsh_completion/"kubectl").write output
    end
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
