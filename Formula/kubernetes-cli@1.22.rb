class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.9",
      revision: "6df4433e288edc9c40c2e344eb336f63fad45cd2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0165ca7444a0e28cb999b971890b2d64d73b345a7d4d9641d25570f740d749ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3950c4f0806e126fce4799f3a81c29d9f7b9e3572b0da669b27ed52bcef76690"
    sha256 cellar: :any_skip_relocation, monterey:       "7873a371b9c5c64ec4bec12e31198561d64847e10b952eb76cf492068b5f57c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cab813470d053f1b193a4340d68f4122fed31a8ad9f37f0d487cfbd4a0832e39"
    sha256 cellar: :any_skip_relocation, catalina:       "a120e39dc9b8b233edcaabaf6aa51de1a96d95ab140c332a0651058213c07164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c7b83894be537b978f18867a8525d87c0256b2825513e4d3999708b22be88f7"
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
