class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.26.1",
      revision: "8f94681cd294aa8cfd3407b8191f6c70214973a4"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df437d83fe4e10ed1e2de03123c64c46b4ac35bbf869e96481e0df16915291a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e428f564fb49519bb6a3898022dd64bbbf95d1c32c26ea251b94f3e045174286"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1840699b8b214fd25e2b583db9eb6314884a4c1e73f8d9de8fe9876b8c6d7348"
    sha256 cellar: :any_skip_relocation, ventura:        "0c1665fc588e0b75040173499131627295ee4d64cb71d3d96eaca69ec358ba1b"
    sha256 cellar: :any_skip_relocation, monterey:       "efca2e8ed0d5e0dfe76a0ef908ea9c5d121f62c69d904cce323f7a0748f112a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cce3a326347751f901d9f406ad14c04bb65ef609e95ee2e045d564d3032f7a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132c7ece6c5aac4996bb630ff9c5e8def5e550fac15344f0385113d16f3301b9"
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
