class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.27.1",
      revision: "4c9411232e10168d7b050c49a1b59f6df9d7ea4b"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74a405001da4c6214858d0879e5612ac78aeb734d6d0fa5765a2021665af7f63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85401bdc2616de0df5a5fd2aa2b741011602cf0068586304d9e372b3a25c0323"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4d23f74c2f372c49f3f4c8cd6ca225dc989e028fccc45ac217adeaf336eae6c"
    sha256 cellar: :any_skip_relocation, ventura:        "ce7d6d528f770ed3f652e54453f5b8b9b0773e94b153319563a504ba7f1a72c2"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0c11cfc40f449adc3ffd9f5da06e90802d9286d808969facf63b7ea77b0687"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4b16ef445c86376abb8cd4626bdef500a617721550bb8903ef4e281af3c98f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5979fb23c99abf925ea01f6ff94f086b1929225fdfa346d25a4a32cd8bac4ae3"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

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
