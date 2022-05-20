class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.24.0",
      revision: "4ce5a8954017644c5420bae81d72b09b735c21f0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e57f8f7ea19d22748d1bcae5cd02b91e71816147712e6dcdcc4f171da3ae7d61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a5c487f78c68daec18129eb96902e8c18cf8e5c46ec6f333b36d4aa193775c1"
    sha256 cellar: :any_skip_relocation, monterey:       "b6c9b1764f5a8f2a9200d0d2aaeea8f5cf2853dbbb91dc64cf601691e0830e40"
    sha256 cellar: :any_skip_relocation, big_sur:        "d561b63e734115f7f17d411dfe5e890dedea58fb1e7d634e7ffe14b2d8b23305"
    sha256 cellar: :any_skip_relocation, catalina:       "33b2eaf5e33c3551407bbf606c70ce0aa4bd0b8741919bac0feb1c64e6e423a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda7bca22f95abb3e0d75d3cbe7739604813bfeb48a3d7c03344b8bbe346e4de"
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
