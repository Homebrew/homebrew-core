class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  license "Apache-2.0"

  stable do
    url "https://github.com/kubernetes/kubernetes.git",
        tag:      "v1.22.4",
        revision: "b695d79d4f967c403a96986f1750a35eb75e75f1"
    depends_on "go@1.16" => :build
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3bb446d2bbd86075c7ca8498c24d7cf6548d5ff84ee664db66c166b2174fd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caae26867c0fec1afe36fc215a8b8001abdaa34dd04b5841575e37a4a8d620bf"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0ce9724fe4f4056a78b105d3b9bd4479b70a9925a985698cf67fd67332a178"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb79038d5ec2d067bd4530c237b2e81021adfe6311de732b15eb16d481f368b"
    sha256 cellar: :any_skip_relocation, catalina:       "a1f2683e96b7a1acbfbff353d0bd74b347c836360351f57321558dace70852de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31dcccdfcba0ee62d713610c1302130f4cc1fb4fe581730f8766aaeddf152e7a"
  end

  # HEAD builds with Go 1.17. Consolidate once v1.23 is released
  head do
    url "https://github.com/kubernetes/kubernetes.git"
    depends_on "go" => :build
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build

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
