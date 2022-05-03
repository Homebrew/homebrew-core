class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.24.0",
      revision: "4ce5a8954017644c5420bae81d72b09b735c21f0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8353365db3dd82faca254a7f826b4cdf9cafefc467f6bc51f0146ef2bc121739"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab0005bcbf276c50a0f517d87c59d08f6da3c6595d280f2aa1006e42032400d4"
    sha256 cellar: :any_skip_relocation, monterey:       "d6edcaf8b6f95488e4153bd58fc9241dcb9fd3fc8f630177e31d9484ec3e49f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3f82ca60285a4e4810cb8c0691b942ff416c1c41b308ea2366eeec79e30437b"
    sha256 cellar: :any_skip_relocation, catalina:       "bce8312f06de902f5b0eba97e8e7ce9fa67acce613c753b3c43d614f9aaaac7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7210c9e12568d927510540a7e162786caa25985f764fbd29271ed7a122ba0587"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

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
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "bash")
    (bash_completion/"kubectl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "zsh")
    (zsh_completion/"_kubectl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "fish")
    (fish_completion/"kubectl.fish").write output

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
