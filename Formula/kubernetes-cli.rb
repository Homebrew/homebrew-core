class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag      => "v1.16.1",
      :revision => "d647ddbd755faf07169599a625faf302ffc34458"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12f363fbee8d29a15ff77030506d7b55f06827e670d89442fadcfe2e0d54f0a9" => :catalina
    sha256 "ab57c3b1d78221728aab91f13372c0020ec067c3292ebd82a221f59fcdb3ebbd" => :mojave
    sha256 "3bc2dfb1f260695095db8a6d221fb530e95def2b289ee77d02684b047a9d2ad1" => :high_sierra
    sha256 "c40b123d5d33c6adf3c2cf6fdcf47337978b6a359062b3f4a9a2ba2102cc08c5" => :sierra
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
