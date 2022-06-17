class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.24.2",
      revision: "f66044f4361b9f1f96f0053dd46cb7dce5e990a8"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61abc1468c831b2290aab7c1eaaa88c8a7d7010a438ac65fb9f9b8ea43d69589"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7edf620cbf977b2bd180b39682b24913bbe0ffa6884e51ee30fb96aa7ae9661c"
    sha256 cellar: :any_skip_relocation, monterey:       "b6c15b7ec1524e3a92bf3a60e2628790bf073ef9eba2f5ef70c915a57150834d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7ab898925b4b21ad1bcc1af7cb7671b303a5c3ff612a54594df0a3423406691"
    sha256 cellar: :any_skip_relocation, catalina:       "e67e1eb07fb61a7c4aea14738d4d6b54c7e79da6e7499709b835d3d569939695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42e2f4fbed12d8e5a55470f3d98e8d0a5f4c72da4377859cd280d67b224ee8e2"
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
