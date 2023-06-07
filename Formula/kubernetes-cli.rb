class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.27.2",
      revision: "7f6f68fdabc4df88cfea2dcf9a19b2b830f1e647"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "752104b8f3af57b5dca4a971a2829aceb99cd7c9ff65c41a02b1c963d83006e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4b59bdfdf3c4e643805ed061ef5b98f234b9f2084e217dfb01b67628569599d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e43b2365416e3caaee0ed0e5b420c6cbaade5df320390a19ba8da6dec4e51e2"
    sha256 cellar: :any_skip_relocation, ventura:        "46038d7527fea8a314a9e943a6653dd82d3b61c6724b61fb9a47d502982fb28b"
    sha256 cellar: :any_skip_relocation, monterey:       "650b96c3d6ab9152be5366e912275f2dc519a97803cee4edab2c45693fc60932"
    sha256 cellar: :any_skip_relocation, big_sur:        "a229c4e5980373ba5e875ad004420bee2b2e2dafbe26252bcf67b73430af34c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418d4dd2ece6f6e2761225fcf568a3cea639a65874063884450355f3908eb747"
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
