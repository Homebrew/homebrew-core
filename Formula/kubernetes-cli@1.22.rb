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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c918d7f7e0a34c6bee08d43ef20e3c979d941a35b5af792e2653e756d932b762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19fe926e2e2ac9b57f3e096c520096d0b3067f87c435108450d34a408c8f2dbe"
    sha256 cellar: :any_skip_relocation, monterey:       "cfedf296cc5d0c25f48e2daf52231982d7d4b7b71f3dc0851ab24c38c3beb606"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3d07dc1edecd13f931752e228c8bf1f1f7ab6b58984c99744d12f3d8d5e4eec"
    sha256 cellar: :any_skip_relocation, catalina:       "2eaad100645c1ae51b047cb5948b9b4f2ed82c275f945e16f0b26026225a76d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d009bd157b21662cba22c1b3a798965103ce4688fb0364b1af84edcf91d22aa9"
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
