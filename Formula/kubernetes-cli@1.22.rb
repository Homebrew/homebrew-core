class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.11",
      revision: "5824e3251d294d324320db85bf63a53eb0767af2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f8094127f253e239be843567717a1de0a0d28e1eebdf4179cabac0d8ae9f86b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05c81c5cb8bc805144fbbc0927c81d6f4f4203170078ba8f8a7cef278afae05b"
    sha256 cellar: :any_skip_relocation, monterey:       "1e67f82bc1b99b3d203be6b86e89a5486f84593bb720f8aab24a5c7650f7668f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e768b6e6f39b3d8b333dcf17569982f7138fddeaacd2c14541a55574629560a"
    sha256 cellar: :any_skip_relocation, catalina:       "aa5d0d5a2f7420ed92bf743c25d3af0a20895e51f709125a001219d82145220f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d056312457b5db5978c62da62d12ccafcf51b8b023565e96cea67e38bc524b6"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-22
  deprecate! date: "2022-08-28", because: :deprecated_upstream
  # disable! date: "2022-10-28", because: :deprecated_upstream

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
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "bash")
    (bash_completion/"kubectl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "zsh")
    (zsh_completion/"_kubectl").write output

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
