class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.9",
      revision: "cea7087b31eb788b75934d769a28f058ab309318"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd54215c277fd437f3398cd4503730adf72ca165182967438d7f5524535ea540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c77f35b2efed7ed34e2b971eee973e8bfccb6a2785ceb100572f253b44078af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348c406ac92f8d2f8d133e4540cfb611bf2d12622f991a7b2d543c77bc123b94"
    sha256 cellar: :any_skip_relocation, sonoma:        "54eb8139b33a1aac462133db9e74d986d0c366b14b42ae1dd32875024fd0b688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "493453aa171281211211b0af767bda84c1ca1834459a3f88dfce539cffd23b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d0b53dd6a9e9919a8376e880be1c8546face95795c26756547554840703a7ea"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion")

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
    assert_match stable.specs[:revision].to_s, version_output
  end
end
