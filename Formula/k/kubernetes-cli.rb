class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.28.1",
      revision: "8dc49c4b984b897d423aab4971090e1879eb4f23"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5632d08c9edef63606c619f7386325db5dcf33c042d63cafc1ccde1e6337387"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "108c5e2c816ca8358078380ec6ab49bf91096c988888b3ffd61a9488146413be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9309cf91a0986277584fbf76054fe887d6997006f92d1cfa38d1b20dc8e4bfc"
    sha256 cellar: :any_skip_relocation, ventura:        "29ef9c843584ad40e00916a0e010511a4fe4bc2f71e857bf607fd4cf520af67e"
    sha256 cellar: :any_skip_relocation, monterey:       "36b54e3fe26b09c8941601312d1b1568f9da9fd0b0e2b061a3acb9525ae1fc20"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c117266ea16b0ad18509c50da4fe2df8cf415a849fc8301d4bde483bb827290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab550d1ed7f758e8fdc5ec54f8d2520321157bfd6bb24bc75cb40a49df59573"
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

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
