class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.15",
      revision: "1d79bc3bcccfba7466c44cc2055d6e7442e140ea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5ff5e1d5d84fcf49d284d56a9a0214858abc0144dbafc26f0076f62669c7f82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbe412b3b37a5e893be6bdb9679e11195b739944a5dbe5efa9749e54459a326e"
    sha256 cellar: :any_skip_relocation, monterey:       "7a124c56ca66a35e2c6593202ba5c776680653c76a2852d2661c32ff12df7cfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3645a760f14ce4ae4ded59466ea81160fed61263980feadeb104f025683abf96"
    sha256 cellar: :any_skip_relocation, catalina:       "21450e0a7d46a889ee2d1420ed9b77977ebb8db52386a755b11bf39639b4140d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0e9b099f80f7d78b3bbaff90244707c47ef0fcfb546c34cd1d9826e1e9cc07"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-22
  deprecate! date: "2022-08-28", because: :deprecated_upstream
  # disable! date: "2022-10-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.16" => :build

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

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl", shells: [:bash, :zsh])

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
