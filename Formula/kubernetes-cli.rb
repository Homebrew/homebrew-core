class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.25.0",
      revision: "a866cbe2e5bbaa01cfd5e969aa3e033f3282a8a2"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80367d7872bba20b28f1570d10c2598f09e7c334e10f567ae50daa7cf2c32eb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f49efe152e34660264a24414ea3b204f94b848011f1e31d9a361f3abf55f198"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec9c95ffe80937ca94ec68ea7acdc939d4ba19ecf5bf14ebadcce5b3078812a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1f5cc6420288626c59d1a237c5be488a6b79b1a053b87f910addb0f2cf09bfe"
    sha256 cellar: :any_skip_relocation, catalina:       "c0ea4ca525429bb2d5954dbaf9839563a1783519738eca98ec444bdd909d5896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10051fbc176e3d5fd37b7b117895b36152c7596fb8d1cf057a2c8dbdd65629b1"
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
