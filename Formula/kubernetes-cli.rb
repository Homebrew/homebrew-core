class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.23.4",
      revision: "e6c093d87ea4cbb530a7b2ae91e54c0842d8308a"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5534ea2c6eb9aebc6c5412e5502a8d5100b30672d3e0f203cddb3d0d6558b8ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff00e95508639baad685f8090e5f55ece4b404c5379c815f1218e1df8a5bcd11"
    sha256 cellar: :any_skip_relocation, monterey:       "a36387677eacf9f5c1d0e321e305b54c8f11d04b4efcf6f1db97802b507ea3a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe5d07b4bd541bdb0aadfa628ffa6086f779674dfda8bf3e48fdeef24e55fc57"
    sha256 cellar: :any_skip_relocation, catalina:       "3725fb170e0caa33a78cd2e6ada1f8482ae5bdf894c742007b0c3be71dc07508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f61d19797f24b0bf90620f2a4bc10577e023d629d4958c18dc993bf4f94d8dba"
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
