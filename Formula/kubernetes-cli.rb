class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.23.5",
      revision: "c285e781331a3785a7f436042c65c5641ce8a9e9"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df608cee3b2aa9f0f4866f9b82c41ff89b52d93c53a16c0c5cd7a42d6a92cea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69d7b8251ab76df3f36785ee191ed84323fa83bdd89f56997451fa184e75917a"
    sha256 cellar: :any_skip_relocation, monterey:       "954520ab97e6db0ee085defb34ed17339122c10e0c402b2ead29fa5fe6ca2018"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bb199003173736bd8460615dea5fc34bf52577cbb41748117819ca32d147717"
    sha256 cellar: :any_skip_relocation, catalina:       "db230143ba10c32abf14de305756e005c1b5eb9d1bcd95dfabc3d8dc66b9b26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc733765e2a1f04f66eb5f3f28e0236eadf3c12e223d16a3f1937041451ef79c"
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
