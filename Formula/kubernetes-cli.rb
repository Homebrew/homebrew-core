class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.25.2",
      revision: "5835544ca568b757a8ecae5c153f317e5736700e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8d50585c3512efbdb462e23386127b6734219e1aa816ce5dabf17e3178ce4c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94886a5a8e98bb3141fa91058eb67ba9ca6738cc8eeb71e3654e6b619d294647"
    sha256 cellar: :any_skip_relocation, monterey:       "275eefb44ccd5cb89de96d7ba694ec68b55ae81f3ceba2f811879c92ff11e652"
    sha256 cellar: :any_skip_relocation, big_sur:        "a908be09b19f39570fa255a2e9da09caed6fc744686443b934846a0c3340eab4"
    sha256 cellar: :any_skip_relocation, catalina:       "5360dc6dc9e62daf89b0e8c411fa2b18c49cd8dcfcddb341871b687063d87a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1aeabe8d508753336cddb0346a89d1ea9254563e141b86bdba37334b2d3b3f"
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
