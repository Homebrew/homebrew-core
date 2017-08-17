class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.7.4",
      :revision => "793658f2d7ca7f064d2bdf606519f9fe1229c381"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb720daa1ccbd668aec58f8272de45fd0bcd954348df76118f654f8b9fdbec93" => :sierra
    sha256 "82a7360401cf84dd358c63a2109d4a412d8d2502323b6b783e0a5fb1baa4eb8a" => :el_capitan
    sha256 "afceb3bea5dd4410f806d07480d24bb157fef45d7e9179d5785e7e364bf89cdc" => :yosemite
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
      # Note: The explicit header to enable auto-loading by compinit
      # can be removed after Kubernetes 1.8.0 when kubernetes/kubernetes#50561
      # becomes available upstream.
      (zsh_completion/"_kubectl").write <<-EOS.undent
        #compdef kubectl
        #{output}
        _complete kubectl
      EOS

      # Install man pages
      # Leave this step for the end as this dirties the git tree
      system "hack/generate-docs.sh"
      man1.install Dir["docs/man/man1/*.1"]
    end
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output if build.stable?
  end
end
