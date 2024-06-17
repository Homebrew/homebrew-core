class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.6",
      revision: "062798d53d83265b9e05f14d85198f74362adaca"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffa6a7d30dec80699b1914505bcbba5e1b9820744c8814b9cc86ec6960f9b2b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67025615629635aed908f96e9032475663a851e44592f0a4acdcb6fd44ac26cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a913edc384adf80adeba87e63bf52bd7f78927ddb847eb7b2755d059729f18d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4489db7aefef230d44fa8793d0c6d26d905e466e0c6f56e67d0cf89f24f2a464"
    sha256 cellar: :any_skip_relocation, ventura:        "006d73c903d68e9e10a919275e8f6d4b1494ce9415b69cc01cdf1c8bd1aa24a4"
    sha256 cellar: :any_skip_relocation, monterey:       "747a4a3ed63e0c7a0cee0d45c22bb02b278733221eb7253072154bf43e5b6ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84f8cec3e784785267fb17bf8fb7f7f1825c8e19f8c5e6afb77caa71e65115d"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.21" => :build

  uses_from_macos "rsync" => :build

  def install
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
