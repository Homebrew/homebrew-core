class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.7",
      revision: "b56e432f2191419647a6a13b9f5867801850f969"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eddced915660c20b511c1cee947c9b1e67f344911a350d8b9f2370b875ceadb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "036e01d57203e786610e1813890f5aae522c247bfdf1c3123d3474af0460cdf3"
    sha256 cellar: :any_skip_relocation, monterey:       "88227487f916ed4a9c4964174a8b97d903745ae851afe41e94ba7045f15e0439"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e2bd7461ed2b0164f7116a46acb557d407436d1c8712b3ab11a647fbcd4ea96"
    sha256 cellar: :any_skip_relocation, catalina:       "5dc7c9864058c74be9eb8a593d8e8c1c1907518ecaf633584004b3611208fab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb9d9ee839576b07575ff508bd5aba4fc4528ed18077002e10ed13e94dd9da7"
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
