class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.5",
      revision: "5c99e2ac2ff9a3c549d9ca665e7bc05a3e18f07e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dedb8727efaa3d87daf55d0d7ca8346e6c2c6093d30361d65ebc1ab28795e616"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de31d093ae8f343523c16f45c176945795a2c20072078df290d5f503b7ec27fe"
    sha256 cellar: :any_skip_relocation, monterey:       "53acdd1ccc07ff486cb43a1b9408b9a9a7e3c897e1608e0bf736d18d2563d9ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "797ecd05edb1cb70b9057cbf45000eb0effc5a6e342d123f6be19711ab2dcf5e"
    sha256 cellar: :any_skip_relocation, catalina:       "a4d4c9e9c116068f22cdc630033b596eded6e952c0fd8b3512cec7e6322ab903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ea4de0e36753e7a580fe3afbeba3c1158d2503f1d5501b8288429fcadfed15"
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
      revision = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
