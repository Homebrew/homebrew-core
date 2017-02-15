class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.5.2",
      :revision => "08e099554f3c31f6e6f07b448ab3ed78d0520507"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    sha256 "61272b68222b5236facc5c3e0385e0a8d02302312aee33a72413257df94c1239" => :sierra
    sha256 "a036fdd2bfd50f1a2e811273aa140ffb1c70fa51ef1725ee4388f18bf67f7e52" => :el_capitan
    sha256 "acc5e4b83bc07df1b027737e6331f4532f7fb4e4f4714b7404525c6ee042b7c3" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes.git",
        :tag => "v1.6.0-alpha.2",
        :revision => "7738f41b958bd8a8018333b9c3eb86c563e1ee1a"
    version "1.6.0-alpha.2"
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
    end
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
  end
end
