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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1528b67378e4a963d2c713a42a2e255c34356e0c8a9da71609b44d4b3d76540b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0718d7295a6e87fe1173450b228af3516a2a9f700552140e5596df0447118996"
    sha256 cellar: :any_skip_relocation, catalina:      "c75410c56abd2a6b673438c6393870d869820d92eb801f8633dc7c1eda4746bf"
    sha256 cellar: :any_skip_relocation, mojave:        "a2c2b54fcfb24a83337f2ac30551a916cf2e918f3ac38136240e1b6416e2570f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "648e50a8afcd000ce1d37f7de94aa02be67df9870d3f2dd442fd429af67e3c55"
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
