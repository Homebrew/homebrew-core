class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.0",
      revision: "c2b5237ccd9c0f1d600d3072634ca66cefdf272f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5f092ec31e361beb556bb217878abdc5d90899eae933bb2070fa6a8e155581cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "c32afe0a4e3ee27324c93d4901b5e13699e2b5ccbed1973617ef6e001b33ac43"
    sha256 cellar: :any_skip_relocation, catalina:      "6c703c3251cab3d37e18c3b5fa33a3a12ab41e7aa11bb8aa4c4b48374b83a4a6"
    sha256 cellar: :any_skip_relocation, mojave:        "f9bcaca2aad2436342424325aac11afeb880b38f133dddaddee412219b339d0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "137b06f0a2ad432fad0c6a5b493232865459d8e813680f2b18b3603cbead744b"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "bash")
    (bash_completion/"kubectl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubectl", "completion", "zsh")
    (zsh_completion/"_kubectl").write output

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/generate-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")

    assert_match "GitTreeState:\"clean\"", version_output

    if build.stable?
      assert_match stable.instance_variable_get(:@resource)
                         .instance_variable_get(:@specs)[:revision],
                   version_output
    end
  end
end
