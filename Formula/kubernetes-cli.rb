class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.26.3",
      revision: "9e644106593f3f4aa98f8a84b23db5fa378900bd"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74d45a9014fed104f214ed073abaf1da46ab40f2f8424347781bea0169899e90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c51d0bc3eb3375e74813ef558efa97362216f4e0ec74d1a3dce2524ec119a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad0a4fc00aa52f211848c5f134245ce054b94dee27434a234a61739c8191e764"
    sha256 cellar: :any_skip_relocation, ventura:        "d3be2017c4c06224f0302a1aeef23d9a6fb3010b289a5a3419f14c79c39bee18"
    sha256 cellar: :any_skip_relocation, monterey:       "9e33e2361de76c5f9bbfdbfbfa69f90c1e912f64a506a3b04e88f6ce25500fbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "55ef53084f2016e19c7364ab882b2d78b9a6e0680f14408f557c7689ae0aa103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc3fc0ed190c2d32dfad78938013acbe11d1193ebd1c490bebf3d4f61ebcb27"
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
