class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.3",
      revision: "6813625b7cd706db5bc7388921be03071e1a492d"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bec474887cbeb601422ba44ecdc63dbce2e1ace2b21019ac2d544cc7c7ffd912"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91db803f66bea30247ef4ca13862df4624ee71e1f1a85af547999969655889c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fbdb8e41e96e637808c1005a20f21c4dca563ee4cd8c41d90b0b0e78dad59a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8cba521a8140262d304d5f83350651ba8ca24ab51fd8f02052cb42dd44740a4"
    sha256 cellar: :any_skip_relocation, ventura:        "fa258cb1fe860b0182d97619c9c16b2185267e1f46c1181a18022d3a79dd337c"
    sha256 cellar: :any_skip_relocation, monterey:       "b904d59bed196ce4debf9a23de3f20c30f5fe0ccbd4a6572a9e9cce153ff7cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761d8a1590bcdd59958e134cd4d2abb5b9a9521fd9596e16223f524180a78d2c"
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
