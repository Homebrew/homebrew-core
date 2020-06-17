class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag      => "v1.18.3",
      :revision => "2e7996e3e2712684bc73f0dec0200d64eec7fe40"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c359b0082317f065a9ecb67fd35e44164f6effc1b1f511f8d553de8ac0d7dfb8" => :catalina
    sha256 "6643f34695d941b24e82afecb6bcce26fc9124773b58c12aaf8d17dadc4d064f" => :mojave
    sha256 "793de8085fb0a63b9171376a8c58732943a0e0a2619aa37a5c5348d7398c1f99" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "rsync" => :build

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
      output = Utils.safe_popen_read("#{bin}/kubectl completion bash")
      (bash_completion/"kubectl").write output

      # Install zsh completion
      output = Utils.safe_popen_read("#{bin}/kubectl completion zsh")
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
