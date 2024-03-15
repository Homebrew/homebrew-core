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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "149bb26966ae33f2476068e8a793fcd29443737ddd00f3d35eeca4fb0da58678"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fde01001bb1ab9edb9e3b5221a7a694bd012befd13751d2ec509cfd010499741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0668dd2817c46e6396ea7be4eefd56f582846d9d88a8da462ce2ea72b5c03b60"
    sha256 cellar: :any_skip_relocation, sonoma:         "528d24a53f1bf5e3f48fe5b281dc8903c63b2420e8581fda207d33bddc9c79c6"
    sha256 cellar: :any_skip_relocation, ventura:        "ddf16ce722d3a1e1f5d1405df06b66fd038a522e94c2e9bf643635d6e69a7643"
    sha256 cellar: :any_skip_relocation, monterey:       "6fa962ab52eb01a0cc2aeb7145288f1659819a8063ef9fdecd178b1eb93dbca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1faa3014c67210d3aec818c4b31d368cf8a8ac95cd68e3fbc8ee1975ee50c8e1"
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
