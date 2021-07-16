class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.21.3",
      revision: "ca643a4d1f7bfe34773c74f79527be4afd95bf39"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d583d9d8b10d71d47eba9653480e16998fdb8eb938352d6587524f6fbad8fe67"
    sha256 cellar: :any_skip_relocation, big_sur:       "fce2a718033ac99a93e8cef1df27911fa8d5c29af5e3e84dc71592bb91706629"
    sha256 cellar: :any_skip_relocation, catalina:      "ad2967ad171d58c6428763152b0742794bf6569ea3db607be015f7f9859a929a"
    sha256 cellar: :any_skip_relocation, mojave:        "fd8cbec16fda8a06c97e16838e4749ba0279910a2365f926cd4ee398c43a18bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81f5720058f91ed0aeb6aa94c2656c4c8c33b3a2f8dbd420db30ccd2ff193d1f"
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
