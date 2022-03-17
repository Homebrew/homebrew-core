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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d223e69a98b97ee98a8f52a8e128f59b02ee550df6b03fa5b616d2d13438d9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bff7df3d90c86d2d572471963a49f20046a7853e0f5443d55fa409afb2031165"
    sha256 cellar: :any_skip_relocation, monterey:       "cfa5d59c7c0181869b635fbf5383e1178e0c6cd43de504237498d64a1be31748"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1e452c19ff742ad4259ad0a7115ee5c6d42c414fcc30f326afacf292540a79b"
    sha256 cellar: :any_skip_relocation, catalina:       "6416e42a4ece78df300893cd3c74aa5c13cbb6c61c0b31d25c804a335c2a1116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d88a9472ec0a8658901295d91304b3a9fdb6c8658cc9cf874d0bc2e10ade96e6"
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
