class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag      => "v1.16.0",
      :revision => "2bd9643cee5b3b3a5ecbd3af49d09018f0773c77"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0ff6595090741872621c7a009020921050815fbab8ad3749486eae25e0cf1fa" => :mojave
    sha256 "00f670da3f68f53e26eaa7df90750854948fa8d1c93269eef3cfc7857299e87e" => :high_sierra
    sha256 "8c3f292cf2b7fc52968d8b47581cbbdcc40bfd853c477b833dcb6fc155429e9f" => :sierra
  end

  depends_on "go@1.12" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/k8s.io/kubernetes"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Race condition still exists in OS X Yosemite
      # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
      ENV.deparallelize { system "make", "generated_files" }

      # Make binary
      system "make", "kubectl"
      bin.install "_output/local/bin/darwin/amd64/kubectl"

      # Install bash completion
      output = Utils.popen_read("#{bin}/kubectl completion bash")
      (bash_completion/"kubectl").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/kubectl completion zsh")
      (zsh_completion/"_kubectl").write output

      prefix.install_metafiles

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
    if build.stable?
      assert_match stable.instance_variable_get(:@resource)
                         .instance_variable_get(:@specs)[:revision],
                   version_output
    end
  end
end
