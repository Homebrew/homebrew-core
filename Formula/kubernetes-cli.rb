class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.23.3",
      revision: "816c97ab8cff8a1c72eccca1026f7820e93e0d25"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2403b415276fe17a0d7998d34b13b8352ab90767a0e854169ad2be8043155a3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ad3b13395c2766ea3d234bb4402817ff09539f5b5a340b780c52d68fd39154e"
    sha256 cellar: :any_skip_relocation, monterey:       "10450b75a7a7fcb80880cf9ddff63b954ac292a8eabfdbd9bf042325432f036a"
    sha256 cellar: :any_skip_relocation, big_sur:        "941f9151210be5802b4ff044c7bc1f296bc187cd80df80fa84717f01f6b27ff0"
    sha256 cellar: :any_skip_relocation, catalina:       "4dafb0187551c1f94300cca5d74f8b59913b9c76105c45f3e7a38c5624a8677d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f1771db09da21107bd83121ac52cd64058a919e4856397a6b405e2778749902"
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
