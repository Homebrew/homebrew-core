class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.3",
      revision: "c92036820499fedefec0f847e2054d824aea6cd1"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "737a1ebcfd616511819adfbcb7beec19dee7c984bfd78637cee331c64c7e0200"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5f72da9826a2488f4b05d9087da38cfad9ffb34d4add776a5dc6249437ab3fc"
    sha256 cellar: :any_skip_relocation, monterey:       "b0f3a7ef85f3e7f869789205cf45972ff73aeadc923ed35049eb54a6d97ff56b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fb49582d12f0aa4f7936abf46191131d9ceca4123eca4e1a08b493aee3a5f0e"
    sha256 cellar: :any_skip_relocation, catalina:       "43f3c5b560f1009a916bc665c4729eab6095b76da1765bf39df93d871e972602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d1c1439c6b04e08e15193c278a8adb5077e1b86076434a209cc79b7744d072"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.16" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    # Deparallelize to avoid race conditions in creating symlinks, creating an error like:
    #   ln: failed to create symbolic link: File exists
    # See https://github.com/kubernetes/kubernetes/issues/106165
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "bash")
    (bash_completion/"kubectl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "zsh")
    (zsh_completion/"_kubectl").write output

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/generate-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
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
