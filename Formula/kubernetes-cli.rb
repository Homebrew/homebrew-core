class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.27.3",
      revision: "25b4e43193bcda6c7328a6d147b1fb73a33f1598"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f625bad8284842be0f597572a54b3684ad7cdce25ec6674c34b2363b9f5a5a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a01e8c9a1e9eacaac651f6f1ab3ff89d0e95ac9bd0922bd0fe547633634cc2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42e38b826e503134b30b1b45ce21dd0bdee77bf4ee9a8671fd3405a90f0a2dd5"
    sha256 cellar: :any_skip_relocation, ventura:        "b7b979295f83fe195e48ebe1f629fff8f42f9ebae3a659194099556887d7da2e"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc9102a30459994a6be394313326c36e094d53730c08ad98e9e1a08f51c2245"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4ffc2aa25bd08930dac63103070fbfab4d803b0e0f7b34ce76741305e1061b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78193d08806cf8b9b63bd9f235c8135fbe90769f63c73834d577635588374bda"
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
