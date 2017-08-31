class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.7.5",
      :revision => "17d7182a7ccbb167074be7a87f0a68bd00d58d97"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e259370ab967a5df3842b582b03325764190165563e1dd2772483b3e80d020a7" => :sierra
    sha256 "95537542596fe61f4f87b28b7c0fe28e7d695ef1bc57d9cb90b62b97fcec92f3" => :el_capitan
    sha256 "1dd259ab2e8182c88c093f19f7581e0e4b1d2a9992f7f4e67e11276ba638db71" => :yosemite
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
