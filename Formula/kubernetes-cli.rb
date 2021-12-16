class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.23.1",
      revision: "86ec240af8cbd1b60bcc4c03c20da9b98005b92e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8076ff961403333b9a0e7e89ea4cd7db74142e115dd7ee878854a2588e54a57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9292b286f31aa819a56788bf403ab4ffde3d42ad4dd960f4119c02e710156a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "c53e51b519eab43bff63139bfecc34f6fc955ef7038de85210c0b587f60c7fb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "92ea9ff7f755a508d4aa3f262ae5d42c820804aea0876f9a3dbe3f6bacb1329c"
    sha256 cellar: :any_skip_relocation, catalina:       "881f3bc60f22c68179a4a49b10c8079c6071648575c4d9a41e56e9ea55072fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f66b60c65a7ca21c71cf9591e217d2f62c5ef726830374fdf1e184a392277cb"
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
      revision = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
