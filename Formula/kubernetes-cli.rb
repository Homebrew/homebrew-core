class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      :tag => "v1.10.3",
      :revision => "2bba0127d85d5a46ab4b778548be28623b32d0b0"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    sha256 "2b821f0003cda3345d098da9d854777296bacb9cf4b7cf381e1bafdbd18f9b7a" => :high_sierra
    sha256 "b2a8b815c45aca284538f45a2705bf8dc74c05a217aa5e7a0c3c98db2d48ee26" => :sierra
    sha256 "ac6ea67a29a7e1b3581538c752097084734af77807831ed787084b081542a49f" => :el_capitan
  end

  # kubernetes-cli will not support go1.10 until version 1.11.x
  depends_on "go@1.9" => :build

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
    assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output if build.stable?
  end
end
