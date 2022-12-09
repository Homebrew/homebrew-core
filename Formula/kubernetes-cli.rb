class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.26.0",
      revision: "b46a3f887ca979b1a5d14fd39cb1af43e7e5d12d"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e10812ce90d3f7f2fa203dbfea7e45464554ef1e6e82a1be4b4c3ad943c50371"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e5db85a24d8b3d891dc776a49fc33a0c02f130069cc2dcaeecd0ae5bae8e452"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3deee8394e9c134b23aa4e400afb66d0becf12b526df3af30f9ec36d0eb6f99d"
    sha256 cellar: :any_skip_relocation, ventura:        "c955c070eda8afe6d27504b99af89808684c3544cae188a3bed0dccdc4fe45fc"
    sha256 cellar: :any_skip_relocation, monterey:       "7e73f105c89acc5d6145893840ceabdb18570d596900db2447329132832ce295"
    sha256 cellar: :any_skip_relocation, big_sur:        "78bf0b100039a477ddd392f5f2f8b1ec1d986dfab3ec66f12aa6e8155facb128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbab8eab57cc34e283fdfebed821896e7bf1429f52dba9751cf1e81c5a32441e"
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
