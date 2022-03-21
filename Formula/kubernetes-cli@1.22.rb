class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.8",
      revision: "7061dbbf75f9f82e8ab21f9be7e8ffcaae8e0d44"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081e8e640f0cdd0ff2c2d9e8440bcfc69f6d99ad17093b21faa49ea66439e6ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bbfd968ec41dc8c0e67fb070e3a3cfc9b75365449477c179c8c19568eb2e490"
    sha256 cellar: :any_skip_relocation, monterey:       "766147c5d6069d3de5952430c28ad0349bb12ce4400fee47ea9f0dc0fea2458e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8a8cf1b146fd85e640917f8c6a22f23007fa51783c6bd27c886a3f1be0b06a5"
    sha256 cellar: :any_skip_relocation, catalina:       "dce87257e925ae4c371ef69452b4d478b45c2eddf0aed4857fab19c2c0b50fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761bcc756c87c13939993c4727c7320ffb981bbb8254a73bcde1473095f651d7"
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
