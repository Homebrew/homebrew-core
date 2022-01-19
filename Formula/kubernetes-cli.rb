class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.23.2",
      revision: "9d142434e3af351a628bffee3939e64c681afa4d"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d83112c71a4eaf166e272bfe6c5a83f353f6cc960c8b839d7ddd9b7f5055eb47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f608cd4a81ca802ab9a37392e7b0538d66cc23da93dbe6c78c3773ef11f19873"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5602dc806ab7b21a958fd75a047ecd763cdc2bdb715fd8b076c405d1efa74e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ab41ec398db8cf62816210c5136b7bb88e0b0750fc9abb8b68240eab65f8e36"
    sha256 cellar: :any_skip_relocation, catalina:       "bc8f58fca32bd5fd0028c6b39aab3c857e1351f1f1f8c07762f99bb7d5b4a110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c6f903231e25f89d11ae55812056ea564348f49fa2818e0103c9776215d8ae"
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
      revision = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
