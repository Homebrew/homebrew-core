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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb48abbc94fc3df921c34de03a1e77085455ce632995d31ac9252d22ee367577"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31c27fcace3f51d69ef3d201dede0b0d58c041a37cf2d2ab1ca4a6df064b95a9"
    sha256 cellar: :any_skip_relocation, monterey:       "36bdd3acde18d00ba58c05cb609d1d21d4dcaebd2ab97c94814cb50b5f63e284"
    sha256 cellar: :any_skip_relocation, big_sur:        "0268bf07ad380c9f81ace3da6386938179fc35a7d4bb8f98a014891e37e72599"
    sha256 cellar: :any_skip_relocation, catalina:       "f96d1d7d3e741da4aa2e06e1688ea54b572fb0f414d19fcf6758ba57a079f429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a2d13a6ef23c1669650a07c3f3056d5bdb50016d2cc51bc45245cf88c633779"
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
