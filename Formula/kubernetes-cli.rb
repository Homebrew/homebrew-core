class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.25.3",
      revision: "434bfd82814af038ad94d62ebe59b133fcb50506"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb92053d88a63eb4c9b1258471aad6f942bd4023ac891434d496a1d959162fab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e19fe4992cbf128b2840f489e42485f15015aed3b961c647fbdc2388e8c0222a"
    sha256 cellar: :any_skip_relocation, monterey:       "70524523af67dd97038f4faf03459e52b508036efe63f2d9bf2156aacdedce85"
    sha256 cellar: :any_skip_relocation, big_sur:        "af4b1cc091d4ad0aa52bbbb8d6c1d6611fe001c814f2ccf18fa9b54de5ab6ecd"
    sha256 cellar: :any_skip_relocation, catalina:       "1d9f1fcb318ebbb39c6fc25595312f61acf0af048279f9abcbff6d5219fd14d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b558a082108b85ad0cf120dbc20419c8fb00c7d3816e59a3d4a4636a81778f50"
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

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

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
