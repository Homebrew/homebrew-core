class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.2",
      revision: "8cc511e399b929453cd98ae65b419c3cc227ec79"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16b18cf1c3f6fbdd0280f6c5b8a8965d87319bf264acc8b558dfedbc0e461075"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cda0c88d17cdf67feefc4c8b8c88cda54aa33fd1aa24090793f6399cf911f7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155a2be571099535d8ad7ee1c13fe0e3c70c1f8f74ee3a2377416c5fcc3d6133"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0a2baa863c86f1fc01eb920e0162aeb14adce8f6880dbc370adc1255e2d235d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c213467542d65aceb845dce082b74da53746f73030e0a645015c8e8e5bc02767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06dc8e558132b328952f20f2fabb53e4a85f0079348d1d019c0a9f928eaad1be"
  end

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
