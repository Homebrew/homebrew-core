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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9374d343ccfb61d79b7214a18e069426a6a5d7ad4165225493801583ac38616"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9db4dea77df8e82e4eb7d10e3cdd4c70995af6ad7bb04d362e63b84b2260a3a8"
    sha256 cellar: :any_skip_relocation, monterey:       "50149d93329aee88762596660da84d9dd857470d37a935643d1655683c7643bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d512759da5a976179bb967bd0edcf58bacef813931d6a9ea36359fbeae1576b4"
    sha256 cellar: :any_skip_relocation, catalina:       "395f5143921100112aec3201a6e045a2bc091d14f60cb0c624fe271df02db6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79f276baa93453fbc8b7e4accaa1c2c3eb4d0bf8e0289a140fcc7ef913315c38"
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
