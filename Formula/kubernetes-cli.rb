class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.24.3",
      revision: "aef86a93758dc3cb2c658dd9657ab4ad4afc21cb"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83d1081fcb669a45a7620db7f7a2c905d5d584226d457857b5acbb093fefcfdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "431c60b8dfd4e23f015275f717986c0b9505b9977e1069bc48216c6ebc128e2c"
    sha256 cellar: :any_skip_relocation, monterey:       "69d7094eadbd7a1ba157a2739464b3cddcf95644f19f76ef148a8492b92c4838"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d9899f2006a021cb5486aca92e9fc397f6d0319c2c82ebc6305eabc73855bb6"
    sha256 cellar: :any_skip_relocation, catalina:       "b4dc96b7ee3fa20b48b70f35008a0f7a1294dfecb22a41e3e2d160fb6dc2b991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24bde1e7a45e06877af75147c0d370c8c1a16122303aaaad719bdbb56aaa670a"
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
