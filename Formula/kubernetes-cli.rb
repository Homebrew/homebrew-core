class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.25.1",
      revision: "e4d4e1ab7cf1bf15273ef97303551b279f0920a9"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e104c25f4825c7f1f46c1c14fb541189626097aa25b1a3a0f2470a37c88c26c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1ff9b35a01e5a5bb6d92dcb2eafa8dee937a6aa88caed5b9ecf1564e87db256"
    sha256 cellar: :any_skip_relocation, monterey:       "66707c7abfc745712344fdf74246f0ab8d2e7478a3f33747bf6ee4042960a47a"
    sha256 cellar: :any_skip_relocation, big_sur:        "24700eceace8adf3c51ced67d5604d274431a884a61a1b9843452b5552de4ea3"
    sha256 cellar: :any_skip_relocation, catalina:       "588bc829f91178204413ccfe6d86e9e5b8d6840b646881410564fef6ff174d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5330e4a49228d3aa670f59bca6a9e8ce61468d61077d7d17a2eb25071f68a2ba"
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
