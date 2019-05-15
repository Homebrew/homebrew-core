class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag      => "v1.14.1",
      :revision => "b7394102d6ef778017f2ca4046abbaa23b88c290"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e9ad04f6f6a144cec593493d170e847d51983e6f9c4fedbc895437bacfee38a" => :mojave
    sha256 "4fd7822963d4e859b0940f21ad1c52d5f7f35d2c2314b19b5d75ad250b29f2aa" => :high_sierra
    sha256 "102c6d7b5b3d009243fbc54b5f2e608824c6cd0d0f7401540802640d1c980bed" => :sierra
  end

  depends_on "go" => :build

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
